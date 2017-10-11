module Members
  class UpdateService < Members::BaseService
    # returns the updated member
    def execute(permission: :update)
      member = find_member!

      permission_target = permission == :override ? source : member
      raise Gitlab::Access::AccessDeniedError unless can?(current_user, action_member_permission(permission, member), permission_target)

      old_access_level = member.human_access

      if member.update_attributes(params)
        after_execute(action: permission, old_access_level: old_access_level, member: member)
        success(member: member)
      else
        error("#{source.class.name} member couldn't be updated.").merge(member: member)
      end
    end

    private

    def find_member!
      condition = params.key?(:user_id) ? { user_id: params.delete(:user_id) } : { id: params.delete(:id) }
      source.members.find_by!(condition)
    end
  end
end
