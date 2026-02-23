import Route from '@ember/routing/route';

import ENV from 'web/config/environment';
import CsvImport from 'web/models/csv-import';

import type { paths } from 'schema/openapi';

type Payload =
  paths['/csv_imports/{id}']['get']['responses']['200']['content']['application/json'];

export default class CsvImportShowRoute extends Route {
  async model({ import_id }: { import_id: string }) {
    const res = await fetch(`${ENV.appURL}/api/csv_imports/${import_id}`);
    const csv_import = (await res.json()) as Payload;

    return CsvImport.fromJSON(csv_import);
  }
}
