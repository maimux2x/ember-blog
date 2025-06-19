import Service from '@ember/service';
import { tracked } from '@glimmer/tracking';

import { Toast } from 'bootstrap';
import { modifier } from 'ember-modifier';
import { scheduleTask } from 'ember-lifeline';

export default class ToastService extends Service {
  @tracked data: { id: string; body: string; bgColor: string }[] = [];
  toasts = new Map<string, Toast>();

  setToast = modifier((el) => {
    const toast = new Toast(el);
    const elementId = el.id;

    this.toasts.set(elementId, toast);

    const handler = () => {
      this.toasts.delete(elementId);
      this.data = this.data.filter(({ id }) => id !== elementId);
    };

    el.addEventListener('hidden.bs.toast', handler);

    return () => {
      el.removeEventListener('hidden.bs.toast', handler);
    };
  });

  show(body: string, bgColor: string) {
    const id = crypto.randomUUID();

    this.data = [...this.data, { id, body, bgColor }];

    scheduleTask(this, 'render', () => {
      const toast = this.toasts.get(id);

      if (!toast) return;

      toast.show();
    });
  }
}
