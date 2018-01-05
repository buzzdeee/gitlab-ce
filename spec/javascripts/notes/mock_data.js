/* eslint-disable */
export const notesDataMock = {
  discussionsPath: '/gitlab-org/gitlab-ce/issues/26/discussions.json',
  lastFetchedAt: '1501862675',
  markdownDocsPath: '/help/user/markdown',
  newSessionPath: '/users/sign_in?redirect_to_referer=yes',
  notesPath: '/gitlab-org/gitlab-ce/noteable/issue/98/notes',
  quickActionsDocsPath: '/help/user/project/quick_actions',
  registerPath: '/users/sign_in?redirect_to_referer=yes#register-pane',
};

export const userDataMock = {
  avatar_url: 'mock_path',
  id: 1,
  name: 'Root',
  path: '/root',
  state: 'active',
  username: 'root',
};

export const noteableDataMock = {
  assignees: [],
  author_id: 1,
  branch_name: null,
  confidential: false,
  create_note_path: '/gitlab-org/gitlab-ce/notes?target_id=98&target_type=issue',
  created_at: '2017-02-07T10:11:18.395Z',
  current_user: {
    can_create_note: true,
    can_update: true,
  },
  deleted_at: null,
  description: '',
  due_date: null,
  human_time_estimate: null,
  human_total_time_spent: null,
  id: 98,
  iid: 26,
  labels: [],
  lock_version: null,
  milestone: null,
  milestone_id: null,
  moved_to_id: null,
  preview_note_path: '/gitlab-org/gitlab-ce/preview_markdown?quick_actions_target_id=98&quick_actions_target_type=Issue',
  project_id: 2,
  state: 'opened',
  time_estimate: 0,
  title: '14',
  total_time_spent: 0,
  updated_at: '2017-08-04T09:53:01.226Z',
  updated_by_id: 1,
  web_url: '/gitlab-org/gitlab-ce/issues/26',
};

export const lastFetchedAt = '1501862675';

export const individualNote = {
  expanded: true,
  id: '0fb4e0e3f9276e55ff32eb4195add694aece4edd',
  individual_note: true,
  notes: [{
    id: 1390,
    attachment: {
      url: null,
      filename: null,
      image: false,
    },
    author: {
      id: 1,
      name: 'Root',
      username: 'root',
      state: 'active',
      avatar_url: 'test',
      path: '/root',
    },
    created_at: '2017-08-01T17: 09: 33.762Z',
    updated_at: '2017-08-01T17: 09: 33.762Z',
    system: false,
    noteable_id: 98,
    noteable_type: 'Issue',
    type: null,
    human_access: 'Owner',
    note: 'sdfdsaf',
    note_html: '<p dir=\'auto\'>sdfdsaf</p>',
    current_user: { can_edit: true },
    discussion_id: '0fb4e0e3f9276e55ff32eb4195add694aece4edd',
    emoji_awardable: true,
    award_emoji: [
      { name: 'baseball', user: { id: 1, name: 'Root', username: 'root' } },
      { name: 'art', user: { id: 1, name: 'Root', username: 'root' } },
    ],
    toggle_award_path: '/gitlab-org/gitlab-ce/notes/1390/toggle_award_emoji',
    report_abuse_path: '/abuse_reports/new?ref_url=http%3A%2F%2Flocalhost%3A3000%2Fgitlab-org%2Fgitlab-ce%2Fissues%2F26%23note_1390&user_id=1',
    path: '/gitlab-org/gitlab-ce/notes/1390',
  }],
  reply_id: '0fb4e0e3f9276e55ff32eb4195add694aece4edd',
};

export const note = {
  "id": 546,
  "attachment": {
    "url": null,
    "filename": null,
    "image": false
  },
  "author": {
    "id": 1,
    "name": "Administrator",
    "username": "root",
    "state": "active",
    "avatar_url": "http://www.gravatar.com/avatar/e64c7d89f26bd1972efa854d13d7dd61?s=80&d=identicon",
    "path": "/root"
  },
  "created_at": "2017-08-10T15:24:03.087Z",
  "updated_at": "2017-08-10T15:24:03.087Z",
  "system": false,
  "noteable_id": 67,
  "noteable_type": "Issue",
  "noteable_iid": 7,
  "type": null,
  "human_access": "Owner",
  "note": "Vel id placeat reprehenderit sit numquam.",
  "note_html": "<p dir=\"auto\">Vel id placeat reprehenderit sit numquam.</p>",
  "current_user": {
    "can_edit": true
  },
  "discussion_id": "d3842a451b7f3d9a5dfce329515127b2d29a4cd0",
  "emoji_awardable": true,
  "award_emoji": [{
    "name": "baseball",
    "user": {
      "id": 1,
      "name": "Administrator",
      "username": "root"
    }
  }, {
    "name": "bath_tone3",
    "user": {
      "id": 1,
      "name": "Administrator",
      "username": "root"
    }
  }],
  "toggle_award_path": "/gitlab-org/gitlab-ce/notes/546/toggle_award_emoji",
  "report_abuse_path": "/abuse_reports/new?ref_url=http%3A%2F%2Flocalhost%3A3000%2Fgitlab-org%2Fgitlab-ce%2Fissues%2F7%23note_546&user_id=1",
  "path": "/gitlab-org/gitlab-ce/notes/546"
  }

export const discussionMock = {
  id: '9e3bd2f71a01de45fd166e6719eb380ad9f270b1',
  reply_id: '9e3bd2f71a01de45fd166e6719eb380ad9f270b1',
  expanded: true,
  notes: [{
    id: 1395,
    attachment: {
      url: null,
      filename: null,
      image: false,
    },
    author: {
      id: 1,
      name: 'Root',
      username: 'root',
      state: 'active',
      avatar_url: null,
      path: '/root',
    },
    created_at: '2017-08-02T10:51:58.559Z',
    updated_at: '2017-08-02T10:51:58.559Z',
    system: false,
    noteable_id: 98,
    noteable_type: 'Issue',
    type: 'DiscussionNote',
    human_access: 'Owner',
    note: 'THIS IS A DICUSSSION!',
    note_html: '<p dir=\'auto\'>THIS IS A DICUSSSION!</p>',
    current_user: {
      can_edit: true,
    },
    discussion_id: '9e3bd2f71a01de45fd166e6719eb380ad9f270b1',
    emoji_awardable: true,
    award_emoji: [],
    toggle_award_path: '/gitlab-org/gitlab-ce/notes/1395/toggle_award_emoji',
    report_abuse_path: '/abuse_reports/new?ref_url=http%3A%2F%2Flocalhost%3A3000%2Fgitlab-org%2Fgitlab-ce%2Fissues%2F26%23note_1395&user_id=1',
    path: '/gitlab-org/gitlab-ce/notes/1395',
  }, {
    id: 1396,
    attachment: {
      url: null,
      filename: null,
      image: false,
    },
    author: {
      id: 1,
      name: 'Root',
      username: 'root',
      state: 'active',
      avatar_url: null,
      path: '/root',
    },
    created_at: '2017-08-02T10:56:50.980Z',
    updated_at: '2017-08-03T14:19:35.691Z',
    system: false,
    noteable_id: 98,
    noteable_type: 'Issue',
    type: 'DiscussionNote',
    human_access: 'Owner',
    note: 'sadfasdsdgdsf',
    note_html: '<p dir=\'auto\'>sadfasdsdgdsf</p>',
    last_edited_at: '2017-08-03T14:19:35.691Z',
    last_edited_by: {
      id: 1,
      name: 'Root',
      username: 'root',
      state: 'active',
      avatar_url: null,
      path: '/root',
    },
    current_user: {
      can_edit: true,
    },
    discussion_id: '9e3bd2f71a01de45fd166e6719eb380ad9f270b1',
    emoji_awardable: true,
    award_emoji: [],
    toggle_award_path: '/gitlab-org/gitlab-ce/notes/1396/toggle_award_emoji',
    report_abuse_path: '/abuse_reports/new?ref_url=http%3A%2F%2Flocalhost%3A3000%2Fgitlab-org%2Fgitlab-ce%2Fissues%2F26%23note_1396&user_id=1',
    path: '/gitlab-org/gitlab-ce/notes/1396',
  }, {
    id: 1437,
    attachment: {
      url: null,
      filename: null,
      image: false,
    },
    author: {
      id: 1,
      name: 'Root',
      username: 'root',
      state: 'active',
      avatar_url: null,
      path: '/root',
    },
    created_at: '2017-08-03T18:11:18.780Z',
    updated_at: '2017-08-04T09:52:31.062Z',
    system: false,
    noteable_id: 98,
    noteable_type: 'Issue',
    type: 'DiscussionNote',
    human_access: 'Owner',
    note: 'adsfasf Should disappear',
    note_html: '<p dir=\'auto\'>adsfasf Should disappear</p>',
    last_edited_at: '2017-08-04T09:52:31.062Z',
    last_edited_by: {
      id: 1,
      name: 'Root',
      username: 'root',
      state: 'active',
      avatar_url: null,
      path: '/root',
    },
    current_user: {
      can_edit: true,
    },
    discussion_id: '9e3bd2f71a01de45fd166e6719eb380ad9f270b1',
    emoji_awardable: true,
    award_emoji: [],
    toggle_award_path: '/gitlab-org/gitlab-ce/notes/1437/toggle_award_emoji',
    report_abuse_path: '/abuse_reports/new?ref_url=http%3A%2F%2Flocalhost%3A3000%2Fgitlab-org%2Fgitlab-ce%2Fissues%2F26%23note_1437&user_id=1',
    path: '/gitlab-org/gitlab-ce/notes/1437',
  }],
  individual_note: false,
};
export const replacedImageDiffHtml = `
<div class="image js-replaced-image" data="">
<div class="two-up view">
<div class="wrap">
<div class="frame deleted">
<img alt="art/google-play-badge.png" src="/Commit451/lab-coat/raw/dae8af3b6c107853c34d8d7b275a052d48c9f2a6/art/google-play-badge.png">
</div>
<p class="image-info">
<span class="meta-filesize">6.15 KB</span>
|
<strong>W:</strong>
<span class="meta-width">214px</span>
|
<strong>H:</strong>
<span class="meta-height">83px</span>
</p>
</div>
<div class="wrap">
<div class="added frame js-image-frame" data-note-type="DiffNote" data-position="{&quot;base_sha&quot;:&quot;dae8af3b6c107853c34d8d7b275a052d48c9f2a6&quot;,&quot;start_sha&quot;:&quot;dae8af3b6c107853c34d8d7b275a052d48c9f2a6&quot;,&quot;head_sha&quot;:&quot;9a74eca5e3ff13de09d25f9d3daa3fd6c77acfb7&quot;,&quot;old_path&quot;:&quot;art/google-play-badge.png&quot;,&quot;new_path&quot;:&quot;art/google-play-badge.png&quot;,&quot;position_type&quot;:&quot;image&quot;,&quot;width&quot;:512,&quot;height&quot;:512,&quot;x&quot;:132,&quot;y&quot;:294}">
<img alt="art/google-play-badge.png" draggable="false" src="/Commit451/lab-coat/raw/9a74eca5e3ff13de09d25f9d3daa3fd6c77acfb7/art/google-play-badge.png" style="width: 452px;">
</div>

<p class="image-info">
<span class="meta-filesize">109 KB</span>
|
<strong>W:</strong>
<span class="meta-width">512px</span>
|
<strong>H:</strong>
<span class="meta-height">512px</span>
</p>
</div>
</div>
<div class="swipe view hide">
<div class="swipe-frame">
<div class="frame deleted">
<img alt="art/google-play-badge.png" src="/Commit451/lab-coat/raw/dae8af3b6c107853c34d8d7b275a052d48c9f2a6/art/google-play-badge.png">
</div>
<div class="swipe-wrap">
<div class="added frame js-image-frame" data-note-type="DiffNote" data-position="{&quot;base_sha&quot;:&quot;dae8af3b6c107853c34d8d7b275a052d48c9f2a6&quot;,&quot;start_sha&quot;:&quot;dae8af3b6c107853c34d8d7b275a052d48c9f2a6&quot;,&quot;head_sha&quot;:&quot;9a74eca5e3ff13de09d25f9d3daa3fd6c77acfb7&quot;,&quot;old_path&quot;:&quot;art/google-play-badge.png&quot;,&quot;new_path&quot;:&quot;art/google-play-badge.png&quot;,&quot;position_type&quot;:&quot;image&quot;,&quot;width&quot;:512,&quot;height&quot;:512,&quot;x&quot;:132,&quot;y&quot;:294}">
<img alt="art/google-play-badge.png" draggable="false" src="/Commit451/lab-coat/raw/9a74eca5e3ff13de09d25f9d3daa3fd6c77acfb7/art/google-play-badge.png">
</div>

</div>
<span class="swipe-bar">
<span class="top-handle"></span>
<span class="bottom-handle"></span>
</span>
</div>
</div>
<div class="onion-skin view hide">
<div class="onion-skin-frame">
<div class="frame deleted">
<img alt="art/google-play-badge.png" src="/Commit451/lab-coat/raw/dae8af3b6c107853c34d8d7b275a052d48c9f2a6/art/google-play-badge.png">
</div>
<div class="added frame js-image-frame" data-note-type="DiffNote" data-position="{&quot;base_sha&quot;:&quot;dae8af3b6c107853c34d8d7b275a052d48c9f2a6&quot;,&quot;start_sha&quot;:&quot;dae8af3b6c107853c34d8d7b275a052d48c9f2a6&quot;,&quot;head_sha&quot;:&quot;9a74eca5e3ff13de09d25f9d3daa3fd6c77acfb7&quot;,&quot;old_path&quot;:&quot;art/google-play-badge.png&quot;,&quot;new_path&quot;:&quot;art/google-play-badge.png&quot;,&quot;position_type&quot;:&quot;image&quot;,&quot;width&quot;:512,&quot;height&quot;:512,&quot;x&quot;:132,&quot;y&quot;:294}">
<img alt="art/google-play-badge.png" draggable="false" src="/Commit451/lab-coat/raw/9a74eca5e3ff13de09d25f9d3daa3fd6c77acfb7/art/google-play-badge.png">
</div>

<div class="controls">
<div class="transparent"></div>
<div class="drag-track">
<div class="dragger" style="left: 0px;"></div>
</div>
<div class="opaque"></div>
</div>
</div>
</div>
</div>
<div class="view-modes">
<ul class="view-modes-menu">
<li class="two-up" data-mode="two-up">2-up</li>
<li class="swipe" data-mode="swipe">Swipe</li>
<li class="onion-skin" data-mode="onion-skin">Onion skin</li>
</ul>
</div>
`;

export const diffDiscussionMock = {
  ...discussionMock,
  truncated_diff_lines: `<tr class="line_holder" id=""> <td class="diff-line-num old_line" data-linenumber="327"> 327 </td><td class="diff-line-num new_line" data-linenumber="327"> 327 </td><td class="line_content noteable_line"> <span id="LC327" class="line" lang="kotlin"> <span class="n">isConfidential</span> <span class="p">))</span> </span> </td></tr><tr class="line_holder" id=""> <td class="diff-line-num old_line" data-linenumber="328"> 328 </td><td class="diff-line-num new_line" data-linenumber="328"> 328 </td><td class="line_content noteable_line"> <span id="LC328" class="line" lang="kotlin"> <span class="p">}</span> <span class="k">else</span> <span class="p">{</span> </span> </td></tr><tr class="line_holder" id=""> <td class="diff-line-num old_line" data-linenumber="329"> 329 </td><td class="diff-line-num new_line" data-linenumber="329"> 329 </td><td class="line_content noteable_line"> <span id="LC329" class="line" lang="kotlin"> <span class="n">observeUpdate</span> <span class="p">(</span> <span class="n">App</span> <span class="p">.</span> <span class="k">get</span> <span class="p">().</span> <span class="n">gitLab</span> <span class="p">.</span> <span class="n">updateIssue</span> <span class="p">(</span> <span class="n">project</span> <span class="p">.</span> <span class="n">id</span> <span class="p">,</span> </span> </td></tr><tr class="line_holder old" id=""> <td class="diff-line-num old old_line" data-linenumber="330"> 330 </td><td class="diff-line-num new_line old" data-linenumber="330"> </td><td class="line_content noteable_line old"> <span id="LC330" class="line" lang="kotlin"> <span class="n">issue</span> <span class="o">!!</span> <span class="p">.</span> <span class="n">id</span> <span class="p">,</span> </span> </td></tr>`,
  diff_file: {
    submodule: false,
    submoduleLink: '<a href="/bha">Submodule</a>', // submodule_link(blob, diff_file.content_sha, diff_file.repository)
    discussionPath: '/something',
    renamedFile: false,
    deletedFile: false,
    modeChanged: false,
    aMode: '100755',
    bMode: '100644',
    filePath: 'some/file/path.rb',
    oldPath: '',
    newPath: '',
    fileTypeIcon: 'fa-file-image-o', // file_type_icon_class('file', diff_file.b_mode, diff_file.file_path)
    text: true,
  },
}

export const imageDiffDiscussionMock = {
  ...discussionMock,
  diff_discussion: true,
  diff_file: {
    submodule: false,
    submoduleLink: '<a href="/bha">Submodule</a>', // submodule_link(blob, diff_file.content_sha, diff_file.repository)
    discussionPath: '/something',
    renamedFile: false,
    deletedFile: false,
    modeChanged: false,
    aMode: '100755',
    bMode: '100644',
    filePath: 'some/file/path.rb',
    oldPath: '',
    newPath: '',
    fileTypeIcon: 'fa-file-image-o', // file_type_icon_class('file', diff_file.b_mode, diff_file.file_path)
    text: false,
  },
  replaced_image_diff_html: replacedImageDiffHtml,
}

export const loggedOutnoteableData = {
  "id": 98,
  "iid": 26,
  "author_id": 1,
  "description": "",
  "lock_version": 1,
  "milestone_id": null,
  "state": "opened",
  "title": "asdsa",
  "updated_by_id": 1,
  "created_at": "2017-02-07T10:11:18.395Z",
  "updated_at": "2017-08-08T10:22:51.564Z",
  "deleted_at": null,
  "time_estimate": 0,
  "total_time_spent": 0,
  "human_time_estimate": null,
  "human_total_time_spent": null,
  "milestone": null,
  "labels": [],
  "branch_name": null,
  "confidential": false,
  "assignees": [{
    "id": 1,
    "name": "Root",
    "username": "root",
    "state": "active",
    "avatar_url": null,
    "web_url": "http://localhost:3000/root"
  }],
  "due_date": null,
  "moved_to_id": null,
  "project_id": 2,
  "web_url": "/gitlab-org/gitlab-ce/issues/26",
  "current_user": {
    "can_create_note": false,
    "can_update": false
  },
  "create_note_path": "/gitlab-org/gitlab-ce/notes?target_id=98&target_type=issue",
  "preview_note_path": "/gitlab-org/gitlab-ce/preview_markdown?quick_actions_target_id=98&quick_actions_target_type=Issue"
}

export const INDIVIDUAL_NOTE_RESPONSE_MAP = {
  'GET': {
    '/gitlab-org/gitlab-ce/issues/26/discussions.json': [{
      "id": "0fb4e0e3f9276e55ff32eb4195add694aece4edd",
      "reply_id": "0fb4e0e3f9276e55ff32eb4195add694aece4edd",
      "expanded": true,
      "notes": [{
        "id": 1390,
        "attachment": {
          "url": null,
          "filename": null,
          "image": false
        },
        "author": {
          "id": 1,
          "name": "Root",
          "username": "root",
          "state": "active",
          "avatar_url": null,
          "path": "/root"
        },
        "created_at": "2017-08-01T17:09:33.762Z",
        "updated_at": "2017-08-01T17:09:33.762Z",
        "system": false,
        "noteable_id": 98,
        "noteable_type": "Issue",
        "type": null,
        "human_access": "Owner",
        "note": "sdfdsaf",
        "note_html": "\u003cp dir=\"auto\"\u003esdfdsaf\u003c/p\u003e",
        "current_user": {
          "can_edit": true
        },
        "discussion_id": "0fb4e0e3f9276e55ff32eb4195add694aece4edd",
        "emoji_awardable": true,
        "award_emoji": [{
          "name": "baseball",
          "user": {
            "id": 1,
            "name": "Root",
            "username": "root"
          }
        }, {
          "name": "art",
          "user": {
            "id": 1,
            "name": "Root",
            "username": "root"
          }
        }],
        "toggle_award_path": "/gitlab-org/gitlab-ce/notes/1390/toggle_award_emoji",
        "report_abuse_path": "/abuse_reports/new?ref_url=http%3A%2F%2Flocalhost%3A3000%2Fgitlab-org%2Fgitlab-ce%2Fissues%2F26%23note_1390\u0026user_id=1",
        "path": "/gitlab-org/gitlab-ce/notes/1390"
      }],
      "individual_note": true
      }, {
      "id": "70d5c92a4039a36c70100c6691c18c27e4b0a790",
      "reply_id": "70d5c92a4039a36c70100c6691c18c27e4b0a790",
      "expanded": true,
      "notes": [{
        "id": 1391,
        "attachment": {
          "url": null,
          "filename": null,
          "image": false
        },
        "author": {
          "id": 1,
          "name": "Root",
          "username": "root",
          "state": "active",
          "avatar_url": null,
          "path": "/root"
        },
        "created_at": "2017-08-02T10:51:38.685Z",
        "updated_at": "2017-08-02T10:51:38.685Z",
        "system": false,
        "noteable_id": 98,
        "noteable_type": "Issue",
        "type": null,
        "human_access": "Owner",
        "note": "New note!",
        "note_html": "\u003cp dir=\"auto\"\u003eNew note!\u003c/p\u003e",
        "current_user": {
          "can_edit": true
        },
        "discussion_id": "70d5c92a4039a36c70100c6691c18c27e4b0a790",
        "emoji_awardable": true,
        "award_emoji": [],
        "toggle_award_path": "/gitlab-org/gitlab-ce/notes/1391/toggle_award_emoji",
        "report_abuse_path": "/abuse_reports/new?ref_url=http%3A%2F%2Flocalhost%3A3000%2Fgitlab-org%2Fgitlab-ce%2Fissues%2F26%23note_1391\u0026user_id=1",
        "path": "/gitlab-org/gitlab-ce/notes/1391"
      }],
      "individual_note": true
    }],
    '/gitlab-org/gitlab-ce/noteable/issue/98/notes': {
      last_fetched_at: 1512900838,
      notes: [],
    },
  },
  'PUT': {
    '/gitlab-org/gitlab-ce/notes/1471': {
      "commands_changes": null,
      "valid": true,
      "id": 1471,
      "attachment": null,
      "author": {
        "id": 1,
        "name": "Root",
        "username": "root",
        "state": "active",
        "avatar_url": null,
        "path": "/root"
      },
      "created_at": "2017-08-08T16:53:00.666Z",
      "updated_at": "2017-12-10T11:03:21.876Z",
      "system": false,
      "noteable_id": 124,
      "noteable_type": "Issue",
      "noteable_iid": 29,
      "type": "DiscussionNote",
      "human_access": "Owner",
      "note": "Adding a comment",
      "note_html": "\u003cp dir=\"auto\"\u003eAdding a comment\u003c/p\u003e",
      "last_edited_at": "2017-12-10T11:03:21.876Z",
      "last_edited_by": {
        "id": 1,
        "name": 'Root',
        "username": 'root',
        "state": 'active',
        "avatar_url": null,
        "path": '/root',
      },
      "current_user": {
        "can_edit": true
      },
      "discussion_id": "a3ed36e29b1957efb3b68c53e2d7a2b24b1df052",
      "emoji_awardable": true,
      "award_emoji": [],
      "toggle_award_path": "/gitlab-org/gitlab-ce/notes/1471/toggle_award_emoji",
      "report_abuse_path": "/abuse_reports/new?ref_url=http%3A%2F%2Flocalhost%3A3000%2Fgitlab-org%2Fgitlab-ce%2Fissues%2F29%23note_1471\u0026user_id=1",
      "path": "/gitlab-org/gitlab-ce/notes/1471"
    },
  }
};

export const DISCUSSION_NOTE_RESPONSE_MAP = {
  ...INDIVIDUAL_NOTE_RESPONSE_MAP,
  'GET': {
    ...INDIVIDUAL_NOTE_RESPONSE_MAP.GET,
    '/gitlab-org/gitlab-ce/issues/26/discussions.json': [{
      "id": "a3ed36e29b1957efb3b68c53e2d7a2b24b1df052",
      "reply_id": "a3ed36e29b1957efb3b68c53e2d7a2b24b1df052",
      "expanded": true,
      "notes": [{
        "id": 1471,
        "attachment": {
          "url": null,
          "filename": null,
          "image": false
        },
        "author": {
          "id": 1,
          "name": "Root",
          "username": "root",
          "state": "active",
          "avatar_url": null,
          "path": "/root"
        },
        "created_at": "2017-08-08T16:53:00.666Z",
        "updated_at": "2017-08-08T16:53:00.666Z",
        "system": false,
        "noteable_id": 124,
        "noteable_type": "Issue",
        "noteable_iid": 29,
        "type": "DiscussionNote",
        "human_access": "Owner",
        "note": "Adding a comment",
        "note_html": "\u003cp dir=\"auto\"\u003eAdding a comment\u003c/p\u003e",
        "current_user": {
          "can_edit": true
        },
        "discussion_id": "a3ed36e29b1957efb3b68c53e2d7a2b24b1df052",
        "emoji_awardable": true,
        "award_emoji": [],
        "toggle_award_path": "/gitlab-org/gitlab-ce/notes/1471/toggle_award_emoji",
        "report_abuse_path": "/abuse_reports/new?ref_url=http%3A%2F%2Flocalhost%3A3000%2Fgitlab-org%2Fgitlab-ce%2Fissues%2F29%23note_1471\u0026user_id=1",
        "path": "/gitlab-org/gitlab-ce/notes/1471"
      }],
      "individual_note": false
    }],
  },
};

export function individualNoteInterceptor(request, next) {
  const body = INDIVIDUAL_NOTE_RESPONSE_MAP[request.method.toUpperCase()][request.url];

  next(request.respondWith(JSON.stringify(body), {
    status: 200,
  }));
}

export function discussionNoteInterceptor(request, next) {
  const body = DISCUSSION_NOTE_RESPONSE_MAP[request.method.toUpperCase()][request.url];

  next(request.respondWith(JSON.stringify(body), {
    status: 200,
  }));
}
