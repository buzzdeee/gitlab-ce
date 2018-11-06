# frozen_string_literal: true

class Projects::BoardsController < Projects::ApplicationController
  include BoardsResponses
  include IssuableCollections

  before_action :check_issues_available!
  before_action :authorize_read_board!, only: [:index, :show]
  before_action :boards, only: :index
  before_action :assign_endpoint_vars
  before_action :redirect_to_recent_board, only: :index

  def index
    respond_with_boards
  end

  def show
    @board = boards.find(params[:id])

    # add/update the board in the recent visited table
    Boards::Visits::CreateService.new(@board.project, current_user).execute(@board) if request.format.html?

    respond_with_board
  end

  private

  def boards
    @boards ||= Boards::ListService.new(project, current_user).execute
  end

  def assign_endpoint_vars
    @boards_endpoint = project_boards_path(project)
    @bulk_issues_path = bulk_update_project_issues_path(project)
    @namespace_path = project.namespace.full_path
    @labels_endpoint = project_labels_path(project)
  end

  def authorize_read_board!
    access_denied! unless can?(current_user, :read_board, project)
  end

  def serialize_as_json(resource)
    resource.as_json(only: [:id])
  end

  def includes_board?(board_id)
    boards.any? { |board| board.id == board_id }
  end

  def redirect_to_recent_board
    return if request.format.json?

    recently_visited = Boards::Visits::LatestService.new(project, current_user).execute

    if recently_visited && includes_board?(recently_visited.board_id)
      redirect_to(namespace_project_board_path(id: recently_visited.board_id), status: :found)
    end
  end
end

Projects::BoardsController.prepend(EE::Boards::BoardsController)
