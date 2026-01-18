import Component from '@glimmer/component';
import { LinkTo } from '@ember/routing';
import { action } from '@ember/object';
import { on } from '@ember/modifier';
import { service } from '@ember/service';
import { tracked } from '@glimmer/tracking';

import formatDatetime from 'web/helpers/format-datetime';
import Pagination from 'web/components/pagination';

import { DirectUpload } from '@rails/activestorage';

import ENV from 'web/config/environment';

import type IndexController from 'web/controllers/admin/posts/index';
import type PostModel from 'web/models/post';
import type RouterService from '@ember/routing/router-service';
import type SessionService from 'web/services/session';

interface Signature {
  Args: {
    controller: IndexController;
    model: {
      posts: PostModel[];
      totalPages: number;
    };
  };
}

export default class extends Component<Signature> {
  @service declare router: RouterService;
  @service declare session: SessionService;

  @tracked file?: File;

  @action
  logout() {
    this.session.deleteToken();

    this.router.transitionTo('login');
  }

  @action
  selectFile(e: Event) {
    this.file = (e.target! as HTMLInputElement).files?.[0]
  }

  @action
  import(e: Event) {
    e.preventDefault();

    if(!this.file) { return; }

    const upload = new DirectUpload(
      this.file,
      `${ENV.appURL}/rails/active_storage/direct_uploads`,
      {
        directUploadWillCreateBlobWithXHR: (xhr: XMLHttpRequest) => {
          xhr.setRequestHeader('Authorization', `Bearer ${this.session.token}`);
        }
      }
    );

    upload.create(async (err: Error | null, blob: { signed_id: string }) => {
      if (err) {
        alert(`Upload failed: ${err.message}`);
        return;
      }

      const res = await fetch(`${ENV.appURL}/api/csv_imports`, {
        method: 'POST',

        headers: {
          'Content-Type': 'application/json',
          Authorization: `Bearer ${this.session.token}`,
        },

        body: JSON.stringify({
          csv_import: {
            file: blob.signed_id
          }
        })
      });
    });
  }

  <template>
    <div class="d-flex justify-content-end">
      <button
        type="button"
        class="btn btn-light"
        {{on "click" this.logout}}
      >Logout</button>
    </div>
    <table class="table">
      <thead>
        <tr>
          <th>Title</th>
          <th>Created at</th>
        </tr>
      </thead>
      <tbody>
        {{#each @model.posts as |post|}}
          <tr>
            <td><LinkTo
                @route="admin.posts.edit"
                @model={{post.id}}
              >{{post.title}}</LinkTo></td>
            <td>{{formatDatetime post.publishedAt}}</td>
          </tr>
        {{/each}}
      </tbody>
    </table>

    <Pagination
      @route="admin.posts"
      @current={{@controller.page}}
      @last={{@model.totalPages}}
    />

    <div class="mt-3">
      <LinkTo @route="admin.posts.new">New</LinkTo>
    </div>

    <form {{on "submit" this.import}}>
      <div class="mb-3">
        <label class="form-label">CSV</label>
        <input type="file" class="form-control" accept=".csv" {{on "change" this.selectFile}} />
      </div>
      <button type="submit" class="btn btn-primary">Import</button>
    </form>
  </template>
}
