import Vue from 'vue';

import axios from '~/lib/utils/axios_utils';
import deleteMilestoneModal from '~/pages/milestones/components/delete_milestone_modal.vue';
import * as urlUtility from '~/lib/utils/url_utility';

import mountComponent from '../../../helpers/vue_mount_component_helper';

describe('delete_milestone_modal.vue', () => {
  const Component = Vue.extend(deleteMilestoneModal);
  const props = {
    issueCount: 1,
    mergeRequestCount: 2,
    milestoneId: 3,
    milestoneTitle: 'my milestone title',
    milestoneUrl: `${gl.TEST_HOST}/delete_milestone_modal.vue/milestone`,
  };
  let vm;

  afterEach(() => {
    vm.$destroy();
  });

  describe('onSubmit', () => {
    beforeEach(() => {
      vm = mountComponent(Component, props);
    });

    it('deletes milestone and redirects to overview page', (done) => {
      const responseURL = `${gl.TEST_HOST}/delete_milestone_modal.vue/milestoneOverview`;
      spyOn(axios, 'delete').and.callFake((url) => {
        expect(url).toBe(props.milestoneUrl);
        return Promise.resolve({
          request: {
            responseURL,
          },
        });
      });
      const redirectSpy = spyOn(urlUtility, 'redirectTo');

      vm.onSubmit()
      .then(() => {
        expect(redirectSpy).toHaveBeenCalledWith(responseURL);
      })
      .then(done)
      .catch(done.fail);
    });

    it('displays error if deleting milestone failed', (done) => {
      const dummyError = new Error('deleting milestone failed');
      dummyError.response = { status: 418 };
      spyOn(axios, 'delete').and.callFake((url) => {
        expect(url).toBe(props.milestoneUrl);
        return Promise.reject(dummyError);
      });
      const redirectSpy = spyOn(urlUtility, 'redirectTo');

      vm.onSubmit()
        .catch((error) => {
          expect(error).toBe(dummyError);
          expect(redirectSpy).not.toHaveBeenCalled();
        })
        .then(done)
        .catch(done.fail);
    });
  });

  describe('text', () => {
    it('contains the issue and milestone count', () => {
      vm = mountComponent(Component, props);
      const value = vm.text;

      expect(value).toContain('remove it from 1 issue and 2 merge requests');
    });

    it('contains neither issue nor milestone count', () => {
      vm = mountComponent(Component, { ...props,
        issueCount: 0,
        mergeRequestCount: 0,
      });

      const value = vm.text;

      expect(value).toContain('is not currently used');
    });
  });
});
