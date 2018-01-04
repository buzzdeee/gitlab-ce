<script>
  import axios from '~/lib/utils/axios_utils';

  import Flash from '~/flash';
  import modal from '~/vue_shared/components/modal.vue';
  import { n__, s__, sprintf } from '~/locale';
  import { redirectTo } from '~/lib/utils/url_utility';

  export default {
    components: {
      modal,
    },
    props: {
      issueCount: {
        type: Number,
        required: true,
      },
      mergeRequestCount: {
        type: Number,
        required: true,
      },
      milestoneId: {
        type: Number,
        required: true,
      },
      milestoneTitle: {
        type: String,
        required: true,
      },
      milestoneUrl: {
        type: String,
        required: true,
      },
    },
    computed: {
      text() {
        const milestoneTitle = sprintf('<strong>%{milestoneTitle}</strong>', { milestoneTitle: this.milestoneTitle });

        if (this.issueCount === 0 && this.mergeRequestCount === 0) {
          return sprintf(
            s__(`Milestones|
You’re about to permanently delete the milestone %{milestoneTitle} from this project.
%{milestoneTitle} is not currently used in any issues or merge requests.`),
            {
              milestoneTitle,
            },
            false,
          );
        }

        return sprintf(
          s__(`Milestones|
You’re about to permanently delete the milestone %{milestoneTitle} from this project and remove it from %{issuesWithCount} and %{mergeRequestsWithCount}.
Once deleted, it cannot be undone or recovered.`),
          {
            milestoneTitle,
            issuesWithCount: sprintf(n__('%{count} issue', '%{count} issues', this.issueCount), { count: this.issueCount }),
            mergeRequestsWithCount: sprintf(n__('%{count} merge request', '%{count} merge requests', this.mergeRequestCount), { count: this.mergeRequestCount }),
          },
          false,
        );
      },
      title() {
        return sprintf(s__('Milestones|Delete milestone %{milestoneTitle}?'), { milestoneTitle: this.milestoneTitle });
      },
    },
    methods: {
      onSubmit() {
        return axios.delete(this.milestoneUrl)
          .then((response) => {
            // follow the rediect to milestones overview page
            redirectTo(response.request.responseURL);
          })
          .catch((error) => {
            if (error.response.status === 404) {
              Flash(sprintf(s__('Milestones|Milestone %{milestoneTitle} was not found'), { milestoneTitle: this.milestoneTitle }));
            } else {
              Flash(sprintf(s__('Milestones|Failed to delete milestone %{milestoneTitle}'), { milestoneTitle: this.milestoneTitle }));
            }
            throw error;
          });
      },
    },
  };
</script>

<template>
  <modal
    id="delete-milestone-modal"
    :title="title"
    :text="text"
    kind="danger"
    :primary-button-label="s__('Milestones|Delete milestone')"
    @submit="onSubmit">

    <template
      slot="body"
      slot-scope="props">
      <p v-html="props.text"></p>
    </template>

  </modal>
</template>
