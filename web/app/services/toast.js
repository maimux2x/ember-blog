import Service from '@ember/service';
import { getOwner } from '@ember/owner';

export default class ToastService extends Service {
  show(body, bgColor) {
    const controller = getOwner(this).lookup('controller:application');

    controller.showToast({ body, bgColor });
  }
}
