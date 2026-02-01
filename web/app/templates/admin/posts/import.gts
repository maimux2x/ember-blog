import { LinkTo } from '@ember/routing';

import type { TOC } from '@ember/routing';
import type CsvImportModel from 'web/models/csv-import';

interface Signature {
  Args: {
    model: CsvImportModel;
  };
}

const CsvImportTemplate: TOC<Signature> = <template>
  <h1 class="display-6 mb-4">CSV Import {{@model.id}}</h1>

  <dl class="horizontal">
    <dt>Created</dt>
    <dd>{{@model.createdAt}}</dd>

    <dt>Status</dt>
    <dd>{{@model.status}}</dd>

    {{#if @model.messages}}
      <dt>Error</dt>
      <ul>
        {{#each @model.messages as |error|}}
          <li>line {{error.line}}: {{error.message}}</li>
        {{/each}}
      </ul>
    {{/if}}
  </dl>
  <LinkTo @route="admin.posts">Back</LinkTo>
</template>;

export default CsvImportTemplate;
