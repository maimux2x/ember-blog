import { LinkTo } from '@ember/routing';
import { htmlSafe } from '@ember/template';

import { marked } from 'marked';
import sanitizeHtml from 'sanitize-html';

import type { TOC } from '@ember/component/template-only';
import type PostModel from 'web/models/post';

interface Signature {
  Args: {
    link?: boolean;
    post: PostModel;
  };
}

function renderMarkdown(body: string) {
  return htmlSafe(
    sanitizeHtml(marked.parse(body, { breaks: true }) as string, {
      allowedTags: sanitizeHtml.defaults.allowedTags.concat(['img']),
    }),
  );
}

export default <template>
  <div class="card mb-3">
    <div class="card-body">
      <h2 class="card-title">
        {{#if @link}}
          <LinkTo
            @route="posts.show"
            @model={{@post.id}}
          >{{@post.title}}</LinkTo>
        {{else}}
          {{@post.title}}
        {{/if}}
      </h2>
      <div class="card-text">{{renderMarkdown @post.body}}</div>
      <div class="card-tags">
        {{#each @post.tagNames as |tag|}}
          <LinkTo
            @route="posts.tag"
            @model={{tag}}
            class="badge bg-secondary me-1"
          >{{tag}}</LinkTo>
        {{/each}}
      </div>
    </div>
  </div>
</template> satisfies TOC<Signature>;
