import Component from '@glimmer/component';
import { service } from '@ember/service';
import { LinkTo } from '@ember/routing';
import { pageTitle } from 'ember-page-title';

export default class extends Component {
  @service toast;

  <template>
    {{pageTitle "Web"}}

    <div class="container">
      <h1 class="my-3">
        <LinkTo
          @route="index"
          class="text-decoration-none text-dark"
        >Blog</LinkTo>
      </h1>

      {{outlet}}
    </div>

    <div class="toast-container position-fixed top-0 end-0 p-3">
      {{#each this.toast.data as |toast|}}
        <div
          id={{toast.id}}
          class="toast align-items-center text-bg-{{toast.bgColor}} border-0"
          data-bs-delay="2000"
          role="alert"
          aria-live="assertive"
          aria-atomic="true"
          {{this.toast.setToast}}
        >
          <div class="d-flex">
            <div class="toast-body">
              {{toast.body}}
            </div>
            <button
              type="button"
              class="btn-close btn-close-white me-2 m-auto"
              data-bs-dismiss="toast"
              aria-label="Close"
            ></button>
          </div>
        </div>
      {{/each}}
    </div>
  </template>
}
