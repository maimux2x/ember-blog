import Route from '@ember/routing/route';

import ENV from 'web/config/environment';
import CsvImport from 'web/models/csv-import';

import type { paths } from 'schema/openapi';

type Payload =
  paths['/csv_imports']['get']['responses']['200']['content']['application/json'];

export default class CsvImports extends Route {
  queryParams = {
    page: {
      refreshModel: true,
    },
  };

  async model({ page = 1 }: { page?: number }) {
    const url = new URL(`${ENV.appURL}/api/csv_imports`);

    url.searchParams.set('page', page.toString());

    const res = await fetch(url);
    const { csv_imports, total_pages } = (await res.json()) as Payload;

    return {
      csvImports: csv_imports.map((csv_import) =>
        CsvImport.fromJSON(csv_import),
      ),
      totalPages: total_pages,
    };
  }
}
