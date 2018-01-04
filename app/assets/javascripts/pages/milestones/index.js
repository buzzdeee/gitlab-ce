import deleteMilestoneModal from './components/delete_milestone_modal.vue';

export default {
  el: '#delete-milestone-modal',
  components: {
    deleteMilestoneModal,
  },
  data() {
    return {
      milestoneId: -1,
      milestoneTitle: '',
      milestoneUrl: '',
      issueCount: -1,
      mergeRequestCount: -1,
    };
  },
  mounted() {
    const onDeleteButtonClick = (event) => {
      const button = event.currentTarget;
      this.milestoneId = parseInt(button.dataset.milestoneId, 10);
      this.milestoneTitle = button.dataset.milestoneTitle;
      this.milestoneUrl = button.dataset.milestoneUrl;
      this.issueCount = parseInt(button.dataset.milestoneIssueCount, 10);
      this.mergeRequestCount = parseInt(button.dataset.milestoneMergeRequestCount, 10);
    };

    const deleteMilestoneButtons = document.querySelectorAll('.js-delete-milestone-button');
    for (let i = 0; i < deleteMilestoneButtons.length; i += 1) {
      const button = deleteMilestoneButtons[i];
      button.classList.remove('disabled');
      button.onclick = onDeleteButtonClick;
    }
  },
  render(createElement) {
    return createElement(deleteMilestoneModal, {
      props: {
        milestoneId: this.milestoneId,
        milestoneTitle: this.milestoneTitle,
        milestoneUrl: this.milestoneUrl,
        issueCount: this.issueCount,
        mergeRequestCount: this.mergeRequestCount,
      },
    });
  },
};
