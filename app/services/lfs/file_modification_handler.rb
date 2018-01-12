module Lfs
  class FileModificationHandler
    attr_reader :project, :branch_name

    delegate :repository, to: :project

    def initialize(project, branch_name)
      @project = project
      @branch_name = branch_name
    end

    #TODO: Non-block format could return content,lfs_object
    #      This could then be used by mulit-action which
    #      would have to manually link LfsObjectsProjects
    #
    #      Or could have a batch method which returns lfs_object array or post_actions array
    #      Or could return on_success proc
    #      Or could build up array of on_success or array of lfs_object
    #      and call back into handler.on_success to trigger them
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

    # def on_success
    #   on_success_actions.map(&:call)
    # end

    # def on_success_actions
    #   @on_success_actions ||= []
    # end

    # In the block form this yields content to commit and links LfsObjectsProject on success
    # In the non-block form this returns content to commit and requires handler.on_succes to be called to link LfsObjectsProjects
    # def new_file(file_path, file_content)
    #   content = if !lfs?(file_path)
    #     file_content
    #   else
    #     lfs_pointer_file = Gitlab::Git::LfsPointerFile.new(file_content)
    #     lfs_object = create_lfs_object!(lfs_pointer_file, file_content)

    #     on_success = -> { link_lfs_object!(lfs_object) } #shouldn't do this if block form

    #     lfs_pointer_file.pointer
    #   end

    #   if block_given?
    #     success = yield(content)

    #     on_success.call if success && on_success
    #   else
    #     on_success_actions << on_success if on_success

    #     content
    #   end
    # end


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
