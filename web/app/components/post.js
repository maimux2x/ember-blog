import Component from '@glimmer/component';
import { action } from '@ember/object';
import { marked } from 'marked';
import { htmlSafe } from '@ember/template';
import sanitizeHtml from 'sanitize-html';

export default class PostComponent extends Component {
  @action
  renderMarkdown(body) {
    return htmlSafe(
      sanitizeHtml(marked.parse(body), {
        allowedTags: sanitizeHtml.defaults.allowedTags.concat(['img']),
      }),
    );
  }
}
