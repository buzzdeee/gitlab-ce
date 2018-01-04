import Vue from 'vue';

import Translate from '~/vue_shared/translate';
import milestones from '~/pages/milestones';

export default () => {
  Vue.use(Translate);

  new Vue(milestones); // eslint-disable-line no-new
};
