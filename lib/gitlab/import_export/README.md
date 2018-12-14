# Import/Export Development documentation

Based on the [Import/Export 201 presentation available on YouTube](https://www.youtube.com/watch?v=V3i1OfExotE) 

## Troubleshooting

```ruby
# Rails console
Project.find_by_full_path('group/project').import_state.slice(:jid, :status, :last_error)
> {"jid"=>"414dec93f941a593ea1a6894", "status"=>"finished", "last_error"=>nil}
```

```bash
# Logs
grep JID /var/log/gitlab/sidekiq/current
grep "Import/Export error" /var/log/gitlab/sidekiq/current
grep "Import/Export backtrace" /var/log/gitlab/sidekiq/current
```

## Troubleshooting - performance

### OOM errors

See [Sidekiq Memory Killer][]

`SIDEKIQ_MEMORY_KILLER_MAX_RSS = 2GB in GitLab.com`

_Symptoms:_

```ruby
# Rails console
{ status: started }
```

```bash
# Sidekiq logs
WARN: Work still in progress <struct with JID>
```

[Sidekiq Memory Killer]: https://docs.gitlab.com/ee/administration/operations/sidekiq_memory_killer.html

### Timeouts

```ruby
class StuckImportJobsWorker
  include ApplicationWorker
  include CronjobQueue

  IMPORT_JOBS_EXPIRATION = 15.hours.to_i

  def perform
    import_state_without_jid_count = mark_import_states_without_jid_as_failed!
    import_state_with_jid_count = mark_import_states_with_jid_as_failed!
    ...
```

```bash
Marked stuck import jobs as failed. JIDs: xyz
```

```                                         
  +-----------+    +-----------------------------------+
  |Export Job |--->| Calls ActiveRecord `as_json` and  |
  +-----------+    | `to_json` on all project models   |
                   +-----------------------------------+
                   
  +-----------+    +-----------------------------------+
  |Import Job |--->| Loads all JSON in memory, then    |
  +-----------+    | inserts into the DB in batches    |
                   +-----------------------------------+
```

### Problems: 

- [Slow JSON][] loading/dumping (think millions of builds)
- High memory - we should [split the worker][split-worker] into many
    - Also, see [Stan's analysis][high-memory-usage]

[Slow JSON]: https://gitlab.com/gitlab-org/gitlab-ce/issues/54084
[high-memory-usage]: https://gitlab.com/gitlab-org/gitlab-ce/issues/35389
[split-worker]: https://gitlab.com/gitlab-org/gitlab-ce/issues/54085


### Possible Solutions

* Worker split
* Batch export
* Optimize SQL (AR doing unnecessary SELECTs, and single INSERTs)
* Batch reading/writing to disk
* Move away from AR callbacks (difficult)
* DB COMMIT sweet spot
* [Oj][] would not help
* [Netflix Fast JSON API][] may help (big refactor)

### In the meantime...

[Foreground import][] of big projects for customers.
(Using the import template in the [infrastructure tracker][])

[Foreground import]: https://gitlab.com/gitlab-com/gl-infra/infrastructure/issues/5384

[Oj]: https://github.com/ohler55/oj
[Netflix Fast JSON API]: https://github.com/Netflix/fast_jsonapi
[infrastructure tracker]: https://gitlab.com/gitlab-com/gl-infra/infrastructure/

## Security

* ~3-year-old code
* We should perform a [code audit][] on Import/Export

### Security in the code

```ruby
# AttributeCleaner
# Removes all `_ids` and other prohibited keys
    class AttributeCleaner
      ALLOWED_REFERENCES = RelationFactory::PROJECT_REFERENCES + RelationFactory::USER_REFERENCES + ['group_id']
    
      def clean
        @relation_hash.reject do |key, _value|
          prohibited_key?(key) || !@relation_class.attribute_method?(key) || excluded_key?(key)
        end.except('id')
      end
      
      ...

```

[code audit]: https://gitlab.com/gitlab-org/gitlab-ce/issues/42135


_Check and confirm the additions of new columns_

```ruby
# AttributeConfigurationSpec
<<-MSG
  It looks like #{relation_class}, which is exported using the project Import/Export, has new attributes:

  Please add the attribute(s) to SAFE_MODEL_ATTRIBUTES if you consider this can be exported.
  Otherwise, please blacklist the attribute(s) in IMPORT_EXPORT_CONFIG by adding it to its correspondent
  model in the +excluded_attributes+ section.

  SAFE_MODEL_ATTRIBUTES: #{File.expand_path(safe_attributes_file)}
  IMPORT_EXPORT_CONFIG: #{Gitlab::ImportExport.config_file}
MSG 
```

_Check and confirm the additions of new models_

```ruby
# ModelConfigurationSpec
<<-MSG
  New model(s) <#{new_models.join(',')}> have been added, related to #{parent_model_name}, which is exported by
  the Import/Export feature.

  If you think this model should be included in the export, please add it to `#{Gitlab::ImportExport.config_file}`.

  Definitely add it to `#{File.expand_path(ce_models_yml)}`
  #{"or `#{File.expand_path(ee_models_yml)}` if the model/associations are EE-specific\n" if ee_models_hash.any?}
  to signal that you've handled this error and to prevent it from showing up in the future.
MSG
```

_Detect encrypted or sensitive columns_

```ruby
# ExportFileSpec
<<-MSG
  Found a new sensitive word <#{key_found}>, which is part of the hash #{parent.inspect}    
  If you think this information shouldn't get exported, please exclude the model or attribute in
  IMPORT_EXPORT_CONFIG.

  Otherwise, please add the exception to +safe_list+ in CURRENT_SPEC using #{sensitive_word} as the
  key and the correspondent hash or model as the value.

  Also, if the attribute is a generated unique token, please add it to RelationFactory::TOKEN_RESET_MODELS
  if it needs to be reset (to prevent duplicate column problems while importing to the same instance).

  IMPORT_EXPORT_CONFIG: #{Gitlab::ImportExport.config_file}
  CURRENT_SPEC: #{__FILE__}
MSG
```

## Versioning

```ruby
# ImportExport
module Gitlab
  module ImportExport
    extend self

    # For every version update, the version history in import_export.md has to be kept up to date.
    VERSION = '0.2.4'
```

## Version history <https://gitlab.com/gitlab-org/gitlab-ce/blob/master/doc/user/project/settings/import_export.md>

| GitLab version   | Import/Export version |
| ---------------- | --------------------- |
| 11.1 to current  | 0.2.4                 |
| 10.8             | 0.2.3                 |
| 10.4             | 0.2.2                 |
| ...              | ...                   |
| 8.10.3           | 0.1.3                 |
| 8.10.0           | 0.1.2                 |
| 8.9.5            | 0.1.1                 |
| 8.9.0            | 0.1.0                 |

---

### When to bump the version up

* Renaming models/columns
* Format modifications in the JSON or archive file

### Normally, we don't have to if we...

* Add a new column or a model
* Remove a column or model (unless there is a DB constraint)
* Export new things (such as a new type of upload)


### Integration specs may fail

```bash
bundle exec rake gitlab:import_export:bump_version
```

### Renaming

_RC problem_ - GitLab.com runs an RC, prior to any customers

1. Add rename to `RelationRenameService` in X.Y
2. Remove it from `RelationRenameService` in X.Y + 1 
3. Bump Import/Export version in X.Y + 1

```ruby
module Gitlab
  module ImportExport
    class RelationRenameService
      RENAMES = {
        'pipelines' => 'ci_pipelines' # Added in 11.6, remove in 11.7
      }.freeze
```

## A quick dive into the code

### Import/Export configuration (import_export.yml)

```yaml
# Model relationships to be included in the project import/export
project_tree:
  - labels:
      :priorities
  - milestones:
    - events:
      - :push_event_payload
  - issues:
    - events:
    - ...
```

```yaml
# Only include the following attributes for the models specified.
included_attributes:
  user:
    - :id
    - :email
  ...      
      
```


```yaml
# Do not include the following attributes for the models specified.
excluded_attributes:
  project:
    - :name
    - :path
    - ...
```


```yaml
# Methods
methods:
  labels:
    - :type
  label:
    - :type
```

### Import

_import\_status_: none -> scheduled -> started -> finished/failed

```ruby
# ImportExport::Importer
module Gitlab
  module ImportExport
    class Importer
      def execute
        if import_file && check_version! && restorers.all?(&:restore) && overwrite_project
          project_tree.restored_project
        else
          raise Projects::ImportService::Error.new(@shared.errors.join(', '))
        end
      rescue => e
        raise Projects::ImportService::Error.new(e.message)
      ensure
        remove_import_file
      end
      
      def restorers
        [repo_restorer, wiki_restorer, project_tree, avatar_restorer,
         uploads_restorer, lfs_restorer, statistics_restorer]
      end
```

### Export

```ruby
# ImportExport::ExportService
module Projects
  module ImportExport
    class ExportService < BaseService

      def save_all!
        if save_services
          Gitlab::ImportExport::Saver.save(project: project, shared: @shared)
          notify_success
        else
          cleanup_and_notify_error!
        end
      end

      def save_services
        [version_saver, avatar_saver, project_tree_saver, uploads_saver, repo_saver, 
           wiki_repo_saver, lfs_saver].all?(&:save)
      end
```

# Links
[Import/Export documentation](https://docs.gitlab.com/ee/user/project/settings/import_export.html)

[Import/Export admin documentation](https://docs.gitlab.com/ee/administration/raketasks/project_import_export.html)

[Import/Export API](https://docs.gitlab.com/ee/api/project_import_export.html)

[Manage 201s (including the Import/Export presentation)](https://gitlab.com/gl-retrospectives/manage/issues/7)
