class DiscussionEntity < Grape::Entity
  include RequestAwareEntity

  expose :id, :reply_id
  expose :expanded?, as: :expanded

  expose :notes, using: NoteEntity

  expose :individual_note?, as: :individual_note
  expose :resolvable?, as: :resolvable
  expose :resolved?, as: :resolved
  expose :resolve_path, if: -> (d, _) { d.resolvable? } do |discussion|
    resolve_project_merge_request_discussion_path(discussion.project, discussion.noteable, discussion.id)
  end
  expose :resolve_with_issue_path do |discussion|
    new_project_issue_path(discussion.project, merge_request_to_resolve_discussions_of: discussion.noteable.iid, discussion_to_resolve: discussion.id)
  end

  expose :diff_file, using: DiffFileEntity, if: -> (d, _) { defined? d.diff_file }

  expose :diff_discussion?, as: :diff_discussion

  expose :truncated_diff_lines, if: -> (d, _) { defined? d.diff_file } do |discussion|
    options[:context].render_to_string(
      partial: "projects/diffs/line",
      collection: discussion.truncated_diff_lines,
      as: :line,
      locals: { diff_file: discussion.diff_file,
        discussion_expanded: true,
        plain: true },
      layout: false,
      formats: [:html]
    )
  end
end
