/**
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

goog.provide('org.apache.flex.core.graphics.Rect');

goog.require('org.apache.flex.core.graphics.GraphicShape');



/**
 * @constructor
 * @extends {org.apache.flex.core.graphics.GraphicShape}
 */
org.apache.flex.core.graphics.Rect = function() {
  org.apache.flex.core.graphics.Rect.base(this, 'constructor');

};
goog.inherits(org.apache.flex.core.graphics.Rect,
    org.apache.flex.core.graphics.GraphicShape);


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org.apache.flex.core.graphics.Rect.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'Rect',
                qName: 'org.apache.flex.core.graphics.Rect' }] };


/**
 * @expose
 * @param {number} x The x position of the top-left corner of the rectangle.
 * @param {number} y The y position of the top-left corner.
 * @param {number} width The width of the rectangle.
 * @param {number} height The height of the rectangle.
 */
org.apache.flex.core.graphics.Rect.prototype.drawRect = function(x, y, width, height) {
	var style = this.getStyleStr();
	var rect = document.createElementNS('http://www.w3.org/2000/svg', 'rect');
	rect.setAttribute('style', style);
	rect.setAttribute('x', String(this.get_stroke().get_weight()));
	rect.setAttribute('y', String(this.get_stroke().get_weight()));
	rect.setAttribute('width', String(width));
	rect.setAttribute('height', String(height));
	this.element.appendChild(rect);
	this.resize(x,y,width+this.get_stroke().get_weight()*2,height+this.get_stroke().get_weight()*2);
};
