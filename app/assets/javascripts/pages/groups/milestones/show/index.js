import Vue from 'vue';

import Translate from '~/vue_shared/translate';
import Milestone from '~/milestone';
import Sidebar from '~/right_sidebar';
import milestones from '~/pages/milestones';

export default () => {
  Vue.use(Translate);

  new Vue(milestones); // eslint-disable-line no-new
  new Milestone(); // eslint-disable-line no-new
  new Sidebar(); // eslint-disable-line no-new
};
