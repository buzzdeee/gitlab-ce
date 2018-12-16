# frozen_string_literal: true

module Gitlab
  module DiscussionsDiff
    class FileCollection
      include Gitlab::Utils::StrongMemoize

      def initialize(collection)
        @collection = collection
      end

      # Returns a Gitlab::Diff::File with the given ID (`unique_identifier` in
      # Gitlab::Diff::File).
      def find_by_id(id)
        diff_files_indexed_by_id[id]
      end

      # Writes cache and preloads @highlighted_diff_lines for
      # object IDs, in @collection.
      #
      # highlightable - Diff file `Array` responding to ID. The ID will be used
      # to generate the cache key.
      #
      # - Highlight cache is written just for uncached diff files
      # - The cache content is not updated (there's no need to do so)
      def load_highlight(highlightable)
        ids = highlightable.map(&:id)

        write_cache_if_empty(ids)
        preload_highlighted_lines(ids)
      end

      private

      def write_cache_if_empty(ids)
        mapping = highlighted_lines_by_id(uncached_ids(ids))

        HighlightCache.write_multiple(mapping)
      end

      def preload_highlighted_lines(ids)
        cached_content = read_cache(ids)

        diffs = diff_files_indexed_by_id.values_at(*ids)

        diffs.zip(cached_content).each do |diff, content|
          next unless diff && content

          # The data structure being loaded here is in control
          # of the system and cannot be exploited by
          # user data.
          content = Marshal.load(content) # rubocop:disable Security/MarshalLoad

          highlighted_diff_lines = content.map do |line|
            Gitlab::Diff::Line.init_from_hash(line)
          end

          diff.highlighted_diff_lines = highlighted_diff_lines
        end
      end

      def read_cache(ids)
        HighlightCache.read_multiple(ids)
      end

      def uncached_ids(ids)
        cached_content = read_cache(ids)

        ids.select.each_with_index { |_, i| cached_content[i].nil? }
      end

      def diff_files_indexed_by_id
        strong_memoize(:diff_files_indexed_by_id) do
          diff_files.index_by { |diff| diff.unique_identifier }
        end
      end

      def diff_files
        strong_memoize(:diff_files) do
          @collection.map { |diff| diff.raw_diff_file }
        end
      end

      # Processes the diff lines highlighting for diff files matching the given
      # IDs.
      #
      # Returns an array with [[id, <serialized highlighted lines>], ...]
      def highlighted_lines_by_id(ids)
        diff_files_indexed_by_id.select { |id, _| ids.include?(id) }.map do |id, file|
          raw_content = file.highlighted_diff_lines.map(&:to_hash)

          [id, Marshal.dump(raw_content)]
        end
      end
    end
  end
end
