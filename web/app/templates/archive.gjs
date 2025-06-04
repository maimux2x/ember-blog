import Component from '@glimmer/component';
import { LinkTo } from '@ember/routing';
import { service } from '@ember/service';
import formatDatetime from 'web/helpers/format-datetime';

export default class extends Component {
  @service session;
  @service router;

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
            {{formatDatetime post.createdAt "date"}}
          </time>
        </LinkTo>
      {{/each}}
    </div>
  </template>
}
