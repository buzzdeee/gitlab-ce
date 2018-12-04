# frozen_string_literal: true

module ClusterableActions
  private

  def empty_clusters?
    subject.clusters.empty?
  end
end
