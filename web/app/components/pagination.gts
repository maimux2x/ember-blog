import Component from '@glimmer/component';
import { LinkTo } from '@ember/routing';
import { hash } from '@ember/helper';

import { eq, gt } from 'ember-truth-helpers';

interface Signature {
  Args: {
    current: number;
    last: number;
    route: string;
  };

  Element: HTMLElement;
}

export default class PaginationComponent extends Component<Signature> {
  get pages() {
    return Array.from({ length: this.args.last }, (v, i) => i + 1);
  }

  get prev() {
    const { current } = this.args;
    return current === 1 ? undefined : current - 1;
  }

  get next() {
    const { current, last } = this.args;
    return current === last ? undefined : current + 1;
  }

  <template>
    {{#if (gt @last 1)}}
      <nav class="d-flex justify-content-center" ...attributes>
        <ul class="pagination">
          <li
            class="page-item {{unless this.prev 'disabled' ''}}"
            data-test-start
          >
            {{#if this.prev}}
              <LinkTo
                @route={{@route}}
                @query={{hash page=1}}
                class="page-link"
                aria-label="Start"
              >
                <span aria-hidden="true">&lt;&lt;</span>
              </LinkTo>
            {{else}}
              <a href="#" class="page-link" aria-label="Previous">
                <span aria-hidden="true">&lt;&lt;</span>
              </a>
            {{/if}}
          </li>
          <li
            class="page-item {{unless this.prev 'disabled' ''}}"
            data-test-prev
          >
            {{#if this.prev}}
              <LinkTo
                @route={{@route}}
                @query={{hash page=this.prev}}
                class="page-link"
                aria-label="Start"
              >
                <span aria-hidden="true">&lt;</span>
              </LinkTo>
            {{else}}
              <a href="#" class="page-link" aria-label="Previous">
                <span aria-hidden="true">&lt;</span>
              </a>
            {{/if}}
          </li>

          {{#each this.pages as |page|}}
            <li
              class="page-item {{if (eq page @current) 'active' ''}}"
              data-test-page={{page}}
            >
              <LinkTo
                @route={{@route}}
                @query={{hash page=page}}
                class="page-link"
              >
                {{page}}
              </LinkTo>
            </li>
          {{/each}}

          <li
            class="page-item {{unless this.next 'disabled' ''}}"
            data-test-next
          >
            {{#if this.next}}
              <LinkTo
                @route={{@route}}
                @query={{hash page=this.next}}
                class="page-link"
                aria-label="Next"
              >
                <span aria-hidden="true">&gt;</span>
              </LinkTo>
            {{else}}
              <a href="#" class="page-link" aria-label="Last">
                <span aria-hidden="true">&gt;</span>
              </a>
            {{/if}}
          </li>
          <li
            class="page-item {{unless this.next 'disabled' ''}}"
            data-test-last
          >
            {{#if this.next}}
              <LinkTo
                @route={{@route}}
                @query={{hash page=@last}}
                class="page-link"
                aria-label="Next"
              >
                <span aria-hidden="true">&gt;&gt;</span>
              </LinkTo>
            {{else}}
              <a href="#" class="page-link" aria-label="Last">
                <span aria-hidden="true">&gt;&gt;</span>
              </a>
            {{/if}}
          </li>
        </ul>
      </nav>
    {{/if}}
  </template>
}
