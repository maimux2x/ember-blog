import Component from '@glimmer/component';
import { service } from '@ember/service';
import { LinkTo } from '@ember/routing';
import { pageTitle } from 'ember-page-title';

export default class extends Component {
  @service session;
  @service toast;

  <template>
    {{pageTitle "Web"}}

    <nav class="navbar navbar-expand-lg bg-body-tertiary">
      <div class="container">
        <LinkTo @route="index" class="navbar-brand">Blog</LinkTo>

        <button
          class="navbar-toggler"
          type="button"
          data-bs-toggle="collapse"
          data-bs-target="#navbarNav"
          aria-controls="navbarNav"
          aria-expanded="false"
          aria-label="Toggle navigation"
        >
          <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="navbarNav">
          <ul class="navbar-nav">
            <li class="nav-item">
              <LinkTo @route="archive" class="nav-link">archive</LinkTo>
            </li>
          </ul>
          <ul class="navbar-nav ms-auto">
            <li class="nav-item">
              {{#if this.session.isLogedIn}}
                <LinkTo @route="admin.posts" class="nav-link">admin</LinkTo>
              {{else}}
                <LinkTo @route="login" class="nav-link">login</LinkTo>
              {{/if}}
            </li>
          </ul>
        </div>
      </div>
    </nav>
    <div class="container my-3">
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
