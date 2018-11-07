# frozen_string_literal: true

class ProjectImportEntity < ProjectEntity
  include ImportHelper

  expose :import_source
  expose :import_status
  expose :human_import_status_name
  expose :import_url, as: :provider_link
end
