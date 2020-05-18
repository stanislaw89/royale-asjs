////////////////////////////////////////////////////////////////////////////////
//
//  Licensed to the Apache Software Foundation (ASF) under one or more
//  contributor license agreements.  See the NOTICE file distributed with
//  this work for additional information regarding copyright ownership.
//  The ASF licenses this file to You under the Apache License, Version 2.0
//  (the "License"); you may not use this file except in compliance with
//  the License.  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
////////////////////////////////////////////////////////////////////////////////

package mx.utils
{

COMPILE::SWF
{
import flash.utils.Dictionary;
}

import mx.core.IPropertyChangeNotifier;
import mx.core.IUIComponent;
import mx.core.IUID;
import mx.core.mx_internal;

use namespace mx_internal;

import org.apache.royale.utils.UIDUtil;
import org.apache.royale.utils.BinaryData;

/**
 *  The UIDUtil class is an all-static class
 *  with methods for working with UIDs (unique identifiers) within Flex.
 *  You do not create instances of UIDUtil;
 *  instead you simply call static methods such as the
 *  <code>UIDUtil.createUID()</code> method.
 * 
 *  <p><b>Note</b>: If you have a dynamic object that has no [Bindable] properties 
 *  (which force the object to implement the IUID interface), Flex  adds an 
 *  <code>mx_internal_uid</code> property that contains a UID to the object. 
 *  To avoid having this field 
 *  in your dynamic object, make it [Bindable], implement the IUID interface
 *  in the object class, or set a <coded>uid</coded> property with a value.</p>
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class UIDUtil
{
//    include "../core/Version.as";

    //--------------------------------------------------------------------------
    //
    //  Class variables
    //
    //--------------------------------------------------------------------------

    /** 
     *  This Dictionary records all generated uids for all existing items.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    COMPILE::SWF
    private static var uidDictionary:Dictionary = new Dictionary(true);

    //--------------------------------------------------------------------------
    //
    //  Class methods
    //
    //--------------------------------------------------------------------------

    /**
     *  Generates a UID (unique identifier) based on ActionScript's
     *  pseudo-random number generator and the current time.
     *
     *  <p>The UID has the form
     *  <code>"XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX"</code>
     *  where X is a hexadecimal digit (0-9, A-F).</p>
     *
     *  <p>This UID will not be truly globally unique; but it is the best
     *  we can do without player support for UID generation.</p>
     *
     *  @return The newly-generated UID.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
	public static function createUID():String
    {
        return org.apache.royale.utils.UIDUtil.createUID();
    }

    /**
     * Converts a 128-bit UID encoded as a ByteArray to a String representation.
     * The format matches that generated by createUID. If a suitable ByteArray
     * is not provided, null is returned.
     * 
     * @param ba ByteArray 16 bytes in length representing a 128-bit UID.
     * 
     * @return String representation of the UID, or null if an invalid
     * ByteArray is provided.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public static function fromByteArray(ba:Object):String
    {
        return org.apache.royale.utils.UIDUtil.fromBinary(ba as BinaryData);
    }

    /**
     * A utility method to check whether a String value represents a 
     * correctly formatted UID value. UID values are expected to be 
     * in the format generated by createUID(), implying that only
     * capitalized A-F characters in addition to 0-9 digits are
     * supported.
     * 
     * @param uid The value to test whether it is formatted as a UID.
     * 
     * @return Returns true if the value is formatted as a UID.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public static function isUID(uid:String):Boolean
    {
        return org.apache.royale.utils.UIDUtil.isUID(uid);
    }

    /**
     * Converts a UID formatted String to a ByteArray. The UID must be in the
     * format generated by createUID, otherwise null is returned.
     * 
     * @param String representing a 128-bit UID
     * 
     * @return ByteArray 16 bytes in length representing the 128-bits of the
     * UID or null if the uid could not be converted.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public static function toBinary(uid:String):BinaryData
    {
        return org.apache.royale.utils.UIDUtil.toBinary(uid);
    }

    /**
     *  Returns the UID (unique identifier) for the specified object.
     *  If the specified object doesn't have an UID
     *  then the method assigns one to it.
     *  If a map is specified this method will use the map
     *  to construct the UID.
     *  As a special case, if the item passed in is null,
     *  this method returns a null UID.
     *  
     *  @param item Object that we need to find the UID for.
     *
     *  @return The UID that was either found or generated.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public static function getUID(item:Object):String
    {
        var result:String = null;

        if (item == null)
            return result;

        if (item is IUID)
        {
            result = IUID(item).uid;
            if (result == null || result.length == 0)
            {
                result = createUID();
                IUID(item).uid = result;
            }
        }
        else if ((item is IPropertyChangeNotifier) &&
                 !(item is IUIComponent))
        {
            result = IPropertyChangeNotifier(item).uid;
            if (result == null || result.length == 0)
            {
                result = createUID();
                IPropertyChangeNotifier(item).uid = result;
            }
        }
        else if (item is String)
        {
            return item as String;
        }
        else
        {
            try
            {
                // We don't create uids for XMLLists, but if
                // there's only a single XML node, we'll extract it.
                if (item is XMLList && item.length == 1)
                    item = item[0];

                /* LATER
                if (item is XML)
                {
                    // XML nodes carry their UID on the
                    // function-that-is-a-hashtable they can carry around.
                    // To decorate an XML node with a UID,
                    // we need to first initialize it for notification.
                    // There is a potential performance issue here,
                    // since notification does have a cost, 
                    // but most use cases for needing a UID on an XML node also
                    // require listening for change notifications on the node.
                    var xitem:XML = XML(item);
                    var nodeKind:String = xitem.nodeKind();
                    if (nodeKind == "text" || nodeKind == "attribute")
                        return xitem.toString();

                    var notificationFunction:Function = xitem.notification();
                    if (!(notificationFunction is Function))
                    {
                        // The xml node hasn't already been initialized
                        // for notification, so do so now.
                        notificationFunction =
                            XMLNotifier.initializeXMLForNotification(); 
                        xitem.setNotification(notificationFunction);
                    }

                    // Generate a new uid for the node if necessary.
                    if (notificationFunction["uid"] == undefined)
                        result = notificationFunction["uid"] = createUID();

                    result = notificationFunction["uid"];
                }
                else
                {
                */
                    if ("mx_internal_uid" in item)
                        return item['mx_internal_uid']

                    //something that is not IUID but has 'uid'
                    if ("uid" in item)
                        return item['uid'];

                    COMPILE::SWF
                    {
                    result = uidDictionary[item];
                    }

                    if (!result)
                    {
                        result = createUID();
                        try 
                        {
                            item['mx_internal_uid'] = result;
                        }
                        catch(e:Error)
                        {
                            COMPILE::SWF
                            {
                            uidDictionary[item] = result;
                            }
                        }
                    }
                //}
            }
            catch(e:Error)
            {
                result = item.toString();
            }
        }

        return result;
    }

}

}
