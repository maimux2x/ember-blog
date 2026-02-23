export interface CsvImportError {
  line: number;
  message: string;
}

export interface CsvImportJSON {
  id: number;
  created_at: string;
  status: 'waiting' | 'processing' | 'completed' | 'failed';
  messages: CsvImportError[] | null;
}

export default class CsvImport {
  id: number;
  createdAt: Date;
  status: CsvImportJSON['status'];
  messages: CsvImportError[] | null;

  constructor(
    id: number,
    createdAt: Date,
    status: CsvImportJSON['status'],
    messages: CsvImportError[] | null,
  ) {
    this.id = id;
    this.createdAt = createdAt;
    this.status = status;
    this.messages = messages;
  }

  static fromJSON(json: CsvImportJSON): CsvImport {
    return new CsvImport(
      json.id,
      new Date(json.created_at),
      json.status,
      json.messages,
    );
  }
}
