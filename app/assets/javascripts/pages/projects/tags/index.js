
import Vue from 'vue';

import Translate from '~/vue_shared/translate';

import deleteTagModal from './components/delete_tag_modal.vue';

Vue.use(Translate);

export default () => {
  // eslint-disable-next-line no-new
  new Vue({
    el: '#delete-tag-modal',
    components: {
      deleteTagModal,
    },
    data() {
      return {
        tagName: '',
        url: '',
        redirectUrl: '',
      };
    },
    mounted() {
      const updateModal = (event) => {
        const button = event.currentTarget;
        this.tagName = button.dataset.tagName;
        this.url = button.dataset.url;
        this.redirectUrl = button.dataset.redirectUrl;
      };

      document.querySelectorAll('.js-delete-tag-button')
        .forEach((element) => {
          const button = element;

          if ('protected' in button.dataset) {
            return;
          }

          button.onclick = updateModal;
          button.classList.remove('disabled');
        });
    },
    render(createElement) {
      return createElement('delete-tag-modal', {
        props: {
          tagName: this.tagName,
          url: this.url,
          redirectUrl: this.redirectUrl,
        },
      });
    },
  });
};
