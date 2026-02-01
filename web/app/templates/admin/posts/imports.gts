import { LinkTo } from '@ember/routing';

import Pagination from 'web/components/pagination';

import type { TOC } from '@ember/component/template-only';
import type AdminPostsCsvImportsIndexController from 'web/controllers/admin/posts/impots/indes';
import type CsvImport from 'web/models/csv-import';

export default <template>
  <h1 class="display-6 mb-4">CSV Imports</h1>

  <table class="table">
    <thead>
      <tr>
        <th>ID</th>
        <th>Status</th>
      </tr>
    </thead>
    <tbody>
      {{#each @model.csvImports as |csvImport|}}
        <tr>
          <td>
            <LinkTo @route="admin.posts.import" @model={{csvImport.id}}>
              {{csvImport.id}}
            </LinkTo>
          </td>
          <td>{{csvImport.status}}</td>
        </tr>
      {{/each}}
    </tbody>
  </table>

  <Pagination
    @route="admin.posts.imports"
    @current={{@controller.page}}
    @last={{@model.totalPages}}
  />
</template> satisfies TOC<{
  Args: {
    model: {
      csvImports: CsvImport[];
      totalPages: number;
    }
  }
}>;
