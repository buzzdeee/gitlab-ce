<script>
  import ciIcon from '~/vue_shared/components/ci_icon.vue';
  import loadingIcon from '~/vue_shared/components/loading_icon.vue';
  import Poll from '~/lib/utils/poll';
  import CommitPipelineService from '../services/commit_pipeline_service';
  import Flash from '~/flash';

  export default {
    components: {
      ciIcon,
      loadingIcon,
    },
    props: {
      endpoint: {
        type: String,
        required: true,
      },
    },
    data() {
      return {
        ciStatus: {},
        isLoading: true,
        service: {},
      };
    },
    mounted() {
      this.service = new CommitPipelineService(this.endpoint);
      this.fetchPipelineCommitData();
    },
    methods: {
      successCallback(res) {
        this.ciStatus = res.data.pipelines[0].details.status;
        this.isLoading = false;
      },
      errorCallback(err) {
        Flash(err);
      },
      initPolling() {
        this.poll = new Poll({
          resource: this.service,
          method: 'fetchData',
          successCallback: response => this.successCallback(response),
          errorCallback: this.errorCallback,
        });
        this.poll.makeRequest();
      },
      fetchPipelineCommitData() {
        this.service.fetchData()
        .then(this.successCallback)
        .then(() => {
          this.initPolling();
        })
        .catch(this.errorCallback);
      },
    },
    destroy() {
      this.poll.stop();
    },
  };
</script>
<template>
  <loading-icon
    label="Loading pipelines"
    size="3"
    :inline="true"
    v-if="isLoading"
  />
  <ci-icon
    v-else
    :status="ciStatus"
  />
</template>
