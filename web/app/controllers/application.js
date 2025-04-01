import Controller from '@ember/controller';
import { action } from '@ember/object';
import { modifier } from 'ember-modifier';
import { service } from '@ember/service';
import { tracked } from '@glimmer/tracking';

import { Toast } from 'bootstrap';
import { scheduleTask } from 'ember-lifeline';

export default class ApplicationController extends Controller {
  @service toast;

  @tracked toastData = [];

  toasts = new Map();

  setToast = modifier((el) => {
    const toast = new Toast(el);

    this.toasts.set(el, toast);

    const handler = () => {
      this.toasts.delete(el);
      this.toastData = this.toastData.filter(({ id }) => id !== el.id);
    };

    el.addEventListener('hidden.bs.toast', handler);

    return () => {
      el.removeEventListener('hidden.bs.toast', handler);
    };
  });

  @action
  showToast(data) {
    const id = crypto.randomUUID();

    this.toastData = [...this.toastData, { id, ...data }];

    scheduleTask(this, 'render', () => {
      const entry = [...this.toasts].find(([el]) => el.id === id);

      if (!entry) return;

      const [, toast] = entry;

      toast.show();
    });
  }
}
