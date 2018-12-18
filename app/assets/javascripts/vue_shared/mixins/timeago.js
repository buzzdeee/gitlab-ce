import { formatDate, getTimeago } from '../../lib/utils/datetime_utility';

/**
 * Mixin with time ago methods used in some vue components
 */
export default {
  methods: {
    timeFormated(time) {
      const timeago = getTimeago();

      return timeago.format(new Date(time));
    },

    tooltipTitle(time) {
      return formatDate(time);
    },
  },
};
