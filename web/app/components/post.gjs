import { marked } from 'marked';
import { htmlSafe } from '@ember/template';
import { LinkTo } from '@ember/routing';
import sanitizeHtml from 'sanitize-html';

function renderMarkdown(body) {
  return htmlSafe(
    sanitizeHtml(marked.parse(body, { breaks: true }), {
      allowedTags: sanitizeHtml.defaults.allowedTags.concat(['img']),
    }),
  );
}

<template>
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
</template>
