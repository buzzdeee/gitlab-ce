# frozen_string_literal: true

require 'spec_helper'

describe Gitlab::DiscussionsDiff::FileCollection do
  let(:merge_request) { create(:merge_request) }
  let!(:diff_note_a) { create(:diff_note_on_merge_request, project: merge_request.project, noteable: merge_request) }
  let!(:diff_note_b) { create(:diff_note_on_merge_request, project: merge_request.project, noteable: merge_request) }
  let(:note_diff_file_a) { diff_note_a.note_diff_file }
  let(:note_diff_file_b) { diff_note_b.note_diff_file }

  subject { described_class.new([note_diff_file_a, note_diff_file_b]) }

  describe '#load_highlight', :clean_gitlab_redis_shared_state do
    it 'writes uncached diffs highlight' do
      file_a_caching_content = diff_note_a.diff_file.highlighted_diff_lines.map(&:to_hash)
      file_b_caching_content = diff_note_b.diff_file.highlighted_diff_lines.map(&:to_hash)

      expect(Gitlab::DiscussionsDiff::HighlightCache)
        .to receive(:write_multiple)
        .with([[note_diff_file_a.id, Marshal.dump(file_a_caching_content)],
               [note_diff_file_b.id, Marshal.dump(file_b_caching_content)]])
        .and_call_original

      subject.load_highlight([note_diff_file_a, note_diff_file_b])
    end

    it 'does not write cache for already cached file' do
      subject.load_highlight([note_diff_file_a])

      file_b_caching_content = diff_note_b.diff_file.highlighted_diff_lines.map(&:to_hash)

      expect(Gitlab::DiscussionsDiff::HighlightCache)
        .to receive(:write_multiple)
        .with([[note_diff_file_b.id, Marshal.dump(file_b_caching_content)]])
        .and_call_original

      subject.load_highlight([note_diff_file_a, note_diff_file_b])
    end

    it 'does not err when given ID does not exists in @collection' do
      expect { subject.load_highlight([double(id: 999)]) }.not_to raise_error
    end

    it 'loaded diff files have @highlighted_diff_lines' do
      subject.load_highlight([note_diff_file_a])

      diff_file = subject.find_by_id(note_diff_file_a.id)

      expect(diff_file.instance_variable_get(:@highlighted_diff_lines))
        .to all(be_a(Gitlab::Diff::Line))
    end

    it 'not loaded diff files does not have @highlighted_diff_lines' do
      subject.load_highlight([note_diff_file_a])

      diff_file = subject.find_by_id(note_diff_file_b.id)

      expect(diff_file.instance_variable_get(:@highlighted_diff_lines)).to be_nil
    end
  end
end
