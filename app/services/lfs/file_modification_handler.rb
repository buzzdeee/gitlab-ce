module Lfs
  class FileModificationHandler
    attr_reader :project, :branch_name

    delegate :repository, to: :project

    def initialize(project, branch_name)
      @project = project
      @branch_name = branch_name
    end

    def new_file(file_path, file_content)
      if !lfs?(file_path)
        yield(file_content)
      else
        lfs_pointer_file = Gitlab::Git::LfsPointerFile.new(file_content)
        lfs_object = create_lfs_object!(lfs_pointer_file, file_content)
        content = lfs_pointer_file.pointer

        success = yield(content)

        link_lfs_object!(lfs_object) if success
      end
    end

    private

    def lfs?(file_path)
      #TODO: test with missing master branch, e.g. creating initial README.md
      repository.attributes_at(branch_name, file_path)['filter'] == 'lfs'
    end

    def create_lfs_object!(lfs_pointer_file, file_content)
      LfsObject.find_or_create_by(oid: lfs_pointer_file.sha256, size: lfs_pointer_file.size) do |lfs_object|
        lfs_object.file = CarrierWaveStringFile.new(file_content)
      end
    end

    def link_lfs_object!(lfs_object)
      project.lfs_objects << lfs_object #TODO: Do we need to check if it is already linked?
    end
  end
end
