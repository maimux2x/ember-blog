import Component from '@glimmer/component';

export default class PaginationComponent extends Component {
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
}
