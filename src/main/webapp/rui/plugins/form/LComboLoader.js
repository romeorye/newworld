/*
 * @(#) rui plugin
 * build version : 2.4 Release $Revision: 19574 $
 *  
 * Copyright �� LG CNS, Inc. All rights reserved.
 *
 * devon@lgcns.com
 * http://www.dev-on.com
 *
 * Do Not Erase This Comment!!! (�� 二쇱꽍臾몄쓣 吏��곗� 留먭쾬)
 *
 * rui/license.txt瑜� 諛섎뱶�� �쎌뼱蹂닿퀬 �ъ슜�섏떆湲� 諛붾엻�덈떎. License.txt�뚯씪�� �덈�濡� ��젣�섏떆硫� �딅맗�덈떎. 
 *
 * 1. �щ궡 �ъ슜�� KAMS瑜� �듯빐 �붿껌�섏뿬 �ъ슜�덇�瑜� 諛쏆쑝�붿빞 �뚰봽�몄썾�� �쇱씠�쇱뒪 怨꾩빟�쒖뿉 �숈쓽�섎뒗 寃껋쑝濡� 媛꾩＜�⑸땲��.
 * 2. DevOn RUI媛� �ы븿�� �쒗뭹�� �먮ℓ�섏떎 寃쎌슦�먮룄 KAMS瑜� �듯빐 �붿껌�섏뿬 �ъ슜�덇�瑜� 諛쏆쑝�붿빞 �⑸땲��.
 * 3. KAMS瑜� �듯빐 �ъ슜�덇�瑜� 諛쏆� �딆� 寃쎌슦 �뚰봽�몄썾�� �쇱씠�쇱뒪 怨꾩빟�� �꾨컲�� 寃껋쑝濡� 媛꾩＜�⑸땲��.
 * 4. 蹂꾨룄濡� �먮ℓ�� 寃쎌슦�� LGCNS�� �뚰봽�몄썾�� �먮ℓ�뺤콉�� �곕쫭�덈떎. (KAMS�� 臾몄쓽 諛붾엻�덈떎.)
 *
 * (二쇱쓽!) �먯��먯쓽 �덈씫�놁씠 �щ같�� �� �� �놁쑝硫�
 * LG CNS �몃�濡쒖쓽 �좎텧�� �섏뿬�쒕뒗 �� �쒕떎.
 */
(function() {
    /**
     * �щ윭 媛쒖쓽 LCombo瑜� �숈떆�� �앹꽦�섎㈃�� �쒕쾭痢� 濡쒕뵫源뚯� �쒕쾲�� �곸슜�섎뒗 �대옒��
     * @module ui_form
     * @namespace Rui.ui.form
     * @class LComboLoader
     * @sample default
     * @plugin
     * @constructor LComboLoader
     * @param {Object} oConfig The intial LComboLoader.
     */

    Rui.ui.form.LComboLoader = function(config){
        this.config = config || {};
        this.comboList = [];
    };

    Rui.ui.form.LComboLoader.prototype = {












        comboList: null,














        load: function(config) {
            var comboDataSetList = [];

            if(config.comboInfo) {
                for (var i = 0; i < config.comboInfo.length; i++) {
                    var cfg = config.comboInfo[i];
                    var currCombo = null;

                    if(!(cfg instanceof Rui.ui.form.LCombo)){
                        var currCfg = Rui.applyIf(cfg, this.config);
                        currCombo = new Rui.ui.form.LCombo(currCfg);
                    } else {
                        currCombo = cfg;
                    }

                    var idx = -1;
                    for (var j = 0; j < this.comboList.length; j++) {
                        if(this.comboList[j].id == currCombo.id) idx = j;
                    }
                    if(idx == -1) this.comboList.push(currCombo);

                    comboDataSetList.push(currCombo.getDataSet());
                }
            }

            var dataSets = comboDataSetList;
            var me = this;

            if(!config.faliure){
                config.faliure = function(conn) {
                    var e = new Error(conn.responseText);
                    throw e;
                };
            }

            config = Rui.applyIf(config, {
                method : 'POST',
                callback : {
                    success : function(conn) {
                        try {
                            for (var i = 0 ; i < dataSets.length ; i++) {
                                var dataSet = dataSets[i];
                                var dataSetData = dataSet.getReadData(conn);
                                dataSet.loadData(dataSetData, config);
                            }
                            if(me.success) {
                                me.success.call(me, conn);
                            }
                        } catch(e) {
                            throw e;
                        }
                    },
                    failure : config.faliure
               },
                url : null,
                params:{},
                cache: this.cache || false
            });

            var params = '';

            for (var i = 0; i < this.comboList.length; i++) {
                var currParams = this.comboList[i].params;
                if (typeof currParams == 'object') {
                    params += Rui.util.LObject.serialize(currParams) + '&';
                } else { 
                    params += currParams + '&';
                }
            }

            Rui.LConnect._isFormSubmit = false;
            Rui.LConnect.asyncRequest(config.method, config.url, config.callback, params);
            return this;
        },









        getCombo: function(id) {
            for (var i = 0; i < this.comboList.length; i++) {
                if(this.comboList[i].id == id) return this.comboList[i];
            }
            return null;
        },






        getComboList: function() {
            return this.comboList;
        }
    };

})();