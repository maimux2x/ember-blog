import Component from '@glimmer/component';
import Pagination from 'web/components/pagination';
import { LinkTo } from '@ember/routing';
import { service } from '@ember/service';

import formatDatetime from 'web/helpers/format-datetime';

import type ArchiveController from 'web/controllers/archive';
import type PostModel from 'web/models/post';
import type RouterService from '@ember/routing/router-service';
import type SessionService from 'web/services/session';

interface Signature {
  Args: {
    controller: ArchiveController;
    model: {
      posts: PostModel[];
      totalPages: number;
    };
  };
}

export default class extends Component<Signature> {
  @service declare session: SessionService;
  @service declare router: RouterService;

  <template>
    <h2>Archive</h2>
    <div class="list-group">
      {{#each @model.posts as |post|}}
        <LinkTo
          @route="posts.show"
          @model={{post.id}}
          class="list-group-item list-group-item-action d-flex"
          aria-current="true"
        >
          <div class="me-auto">
            {{post.title}}
          </div>
          <time>
            {{formatDatetime post.publishedAt "date"}}
          </time>
        </LinkTo>
      {{/each}}
    </div>

    <Pagination
      @route="archive"
      @current={{@controller.page}}
      @last={{@model.totalPages}}
    />
  </template>
}
