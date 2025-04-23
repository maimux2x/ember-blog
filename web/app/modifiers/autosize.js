import autosize from 'autosize';
import { modifier } from 'ember-modifier';

export default modifier((textarea) => {
  autosize(textarea);
});
