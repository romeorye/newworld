/*
 * @(#) rui_config.js
 * build version : 0.9.2 $Revision: 14723 $
 *
 * Copyright ⓒ LG CNS, Inc. All rights reserved.
 *
 * Do Not Erase This Comment!!! (이 주석문을 지우지 말것)
 *
 * DevOn Rich UI Framework를 실제 프로젝트에 사용하는 경우 DevOn Rich UI 개발담당자에게
 * 프로젝트 정식명칭, 담당자 연락처(Email)등을 mail로 알려야 한다.
 *
 * 소스를 변경하여 사용하는 경우 DevOn Rich UI 개발담당자에게
 * 변경된 소스 전체와 변경된 사항을 알려야 한다.
 * 저작자는 제공된 소스가 유용하다고 판단되는 경우 해당 사항을 반영할 수 있다.
 * 중요한 Idea를 제공하였다고 판단되는 경우 협의하에 저자 List에 반영할 수 있다.
 *
 * (주의!) 원저자의 허락없이 재배포 할 수 없으며
 * LG CNS 외부로의 유출을 하여서는 안 된다.
 */
(function() {
    Rui.namespace('Rui.config');
    Rui.namespace('Rui.message.locale');
    /*
     * Web Root가 '/'가 아닌경우, '/'부터 Web Root까지의 경로를 기술한다.  ex) /WebContent
     */
    
    //개발,운영
    //var contextPath = '',
    
    //local
    var contextPath = '/iris',
        ruiRootPath = '/rui';
    
    contextPath = window._BOOTSTRAP_CONTEXTROOT || contextPath;
    ruiRootPath = window._BOOTSTRAP_RUIROOT || ruiRootPath;
    /*
     * 각 Module별 기본 config값 설정.
     */
    Rui.config.ConfigData = {
        core:
            {
                applicationName: 'DevOn RichUI',
                version: 2.3,
                configFileVersion: 1.5,
                /*
                 * 기본 언어 date, message등에 영향을 준다.
                 * */
                defaultLocale: 'ko_KR',
                contextPath: contextPath,
                ruiRootPath: ruiRootPath,
                message: {
                    /*
                     * 기본 message 객체
                     */
                    defaultMessage: Rui.message.locale.ko_KR,
                    /*
                     * 다국어 지원 message 파일 위치
                     */
                    localePath: '/resources/locale'
                },
                jsunit: {
                    jsPath: contextPath + '/jsunit/app/jsUnitCore.js'
                },
                css: {
                    charset: 'utf-8'
                },
                logger: {
                    /*
                     * logger 출력 여부
                     */
                    show: false,
                    /*
                     * logger expand 여부
                     */
                    expand: false,
                    /*
                     * logger 기본 source 출력  여부
                     */
                    defaultSource: true,
                    /*
                     * logger 기본 source 명
                     */
                    defaultSourceName: 'Component'
                },
                font: {
                },
                debug: {
                    /*
                     * 에러 발생시 debugging 여부
                     */
                    exceptionDebugger : false,
                    notice: true,
                    servers: [ 'localhost', '127.0.0.1']
                },
                useAccessibility: false,
                dateLocale: {
                    //ko: {
                    //    x: '%Y년%B월%d일'
                    //}
                }
            }
        ,
        base:
            {
                dataSetManager: {
                    defaultProperties: {
                        diableCaching: true,
                        timeout: 100000,
                        blankUrl: 'about:blank',
                        defaultSuccessHandler: false,
                        defaultFailureHandler: true,
                        defaultLoadExceptionHandler: true,
                        isCheckedUpdate: true
                    },

                    failureHandler: function(e) {
                        if(typeof loadPanel != 'undefined') loadPanel.hide();
                        if (Rui.getConfig().getFirst('$.core.debug.exceptionDebugger')) {
                            alert('IE나 FireFox의 경우 디버깅 상태로 설정됩니다.');
                            debugger;
                        }
                        
                        if(e.conn && e.conn.status == -1) // timeout
                            Rui.alert(Rui.getMessageManager().get('$.base.msg112'));
                        else {
                            var dt = new Date();
                            var strDate = dt.getFullYear() + '-' + dt.getMonth() + '-' + dt.getDate();
                            strDate +=  ' ' + dt.getHours() + ':' + dt.getMinutes() + ':' + dt.getSeconds();

                            if(typeof e.conn === 'undefined')
                                strStatus = '';
                            else if(e.conn)
                                strStatus = e.conn.status;
                            else
                                strStatus = e.status;
                            //alert('[1] strStatus=>'+strStatus);
                            if( strStatus == '999') {
	                            /*
	                            Rui.alert('(1)[RUI-10000]DateTime:[' + strDate + ']:Status:[' + strStatus + ']<br>'
	                                    + Rui.getMessageManager().get('$.base.msg101') + ' : ' + e.responseText);
	                            */
                            	//Rui.alert(e.conn.responseText);
                            	Rui.alert(Rui.getMessageManager().get('$.message.msgSessionOut')); //세션연결이 종료되었습니다. 다시 로긴해 주시기 바랍니다.
                            	document.location = contextPath + "/common/login/sessionError.do";
                            } else {
                            	Rui.alert(Rui.getMessageManager().get('$.message.msg001'));
                            }                              
                            
                        }
                    },

                    loadExceptionHandler: function(e) {
                        if(typeof loadPanel != 'undefined') loadPanel.hide();
                        if(Rui.getConfig().getFirst('$.core.debug.exceptionDebugger')) {
                            alert('IE나 FireFox의 경우 디버깅 상태로 설정됩니다.');
                            debugger;
                        }
                        
                        var exception = Rui.getException(e.throwObject);
                        if(e.conn && e.conn.status == -1)  // timeout
                            Rui.alert(Rui.getMessageManager().get('$.base.msg112'));
                        else {
                            var dt = new Date();
                            var strDate = dt.getFullYear() + '-' + dt.getMonth() + '-' + dt.getDate();
                            strDate +=  ' ' + dt.getHours() + ':' + dt.getMinutes() + ':' + dt.getSeconds();

                            if(typeof e.conn === 'undefined')
                                strStatus = '';
                            else
                                strStatus = e.conn.status;
                            //alert('[2] strStatus=>'+strStatus);
                            if( strStatus == '999') {
	                            /*
	                            Rui.alert('(2)[RUI-10000]DateTime:[' + strDate + ']:Status:[' + strStatus + ']<br>'
	                                    + Rui.getMessageManager().get('$.base.msg104') + ' : ' + exception.getMessage());
	                            */
                            	//Rui.alert(e.conn.responseText);
                            	Rui.alert(Rui.getMessageManager().get('$.message.msgSessionOut')); //세션연결이 종료되었습니다. 다시 로긴해 주시기 바랍니다.
                            	document.location = contextPath + "/common/login/sessionError.do";
                            } else {
                            	Rui.alert(Rui.getMessageManager().get('$.message.msg001'));
                            }                            
                            //Rui.alert(Rui.getMessageManager().get('$.message.msg001'));
                        }
                        return false;
                    }
                },
                button: {
                    disableDbClick: true,
                    disableDbClickInterval: 500
                },
                layout: {
                    defaultProperties: {
                    }
                },
                dataSet: {
                    defaultProperties: {
                    	method: 'GET',
                        focusFirstRow: 0,
                        timeout: 10000,
                        defaultFailureHandler: true,
                        isClearUnFilterChangeData: false,
                        serializeMetaData: false,
                        readFieldFormater: { date: function(value){
                            if(typeof value == 'number'){
                            	return new Date(value);
                            }else
                            	return Rui.util.LFormat.stringToTimestamp(value);
                        }},
                        writeFieldFormater: { date: Rui.util.LRenderer.dateRenderer('%Y%m%d%H%M%S') }
                    },
                    loadExceptionHandler: function(e) {
                        if(typeof loadPanel != 'undefined') loadPanel.hide();
                        if(Rui.getConfig().getFirst('$.core.debug.exceptionDebugger')) {
                            alert('IE나 FireFox의 경우 디버깅 상태로 설정됩니다.');
                            debugger;
                        }
                        //alert('[3] e.conn.status=>'+e.conn.status);
                        var exception = Rui.getException(e.throwObject);
                        var message = e.throwObject ? e.throwObject.message : e.message;
                        Rui.log(message, 'error', this.otype);
                        if(e.conn && e.conn.status == -1)  // timeout
                            Rui.alert(Rui.getMessageManager().get('$.base.msg112'));
                        else{
                            var dt = new Date();
                            var strDate = dt.getFullYear() + '-' + dt.getMonth() + '-' + dt.getDate();
                            strDate +=  ' ' + dt.getHours() + ':' + dt.getMinutes() + ':' + dt.getSeconds();

                            if(typeof e.conn === 'undefined')
                                strStatus = '';
                            else
                                strStatus = e.conn.status;
                            //alert('[3] strStatus=>'+strStatus);
                            if( strStatus == '999') {
	                            /*
                            	Rui.alert('(3)[RUI-10000]DateTime:[' + strDate + ']:Status:[' + strStatus + ']<br>'
	                                    + Rui.getMessageManager().get('$.base.msg104') + ' : ' + exception.getMessage());
	                            Rui.alert('(4)[RUI-10000]DateTime:[' + strDate + ']:Status:[' + strStatus + ']<br>'
	                                    + Rui.getMessageManager().get('$.base.msg104') + ' : ' + e.conn.responseText);
	                            */
                            	//Rui.alert(e.conn.responseText);
                            	Rui.alert(Rui.getMessageManager().get('$.message.msgSessionOut')); //세션연결이 종료되었습니다. 다시 로긴해 주시기 바랍니다.
                            	document.location = contextPath + "/common/login/sessionError.do";
                            } else {
                            	Rui.alert(Rui.getMessageManager().get('$.message.msg001'));
                            }	
                        }
                        return true;
                    }
                },
                guide: {
                    show: true,
                    limitGuideCount: 3,
                    defaultProperties: {
                        showPageGuide: true
                    }
                }
            }
        ,
        ext:
            {
                browser: {
                    recommend: true,
                    recommendCount: 1,
                    link: 'http://browsehappy.com'
                },
                dialog: {
                    defaultProperties: {
                        constraintoviewport: true,
                        fixedcenter: true,
                        modal: true,
                        hideaftersubmit: true,
                        postmethod: 'none'
                    }
                },
                container: {
                },
                textBox: {
                    defaultProperties: {
                        //dataSetClassName: 'Rui.data.LJsonDataSet',
                        filterMode: 'remote',
                        emptyValue: null
                    },
                    dataSet: {
                    }
                },
                combo: {
                    defaultProperties: {
                        filterMode: 'local',
                        //width: 100,
                        //listWidth: 200,
                        //emptyValue: '--선택--',
                        useEmptyText: true
                    },
                    dataSet: {
                        //valueField: 'value',
                        //displayField: 'text'
                    }
                },
                multicombo: {
                    defaultProperties: {
                    	//다국어 처리를 원할 경우 rui_config.js 가장 아래 LMultiCombo 다국어처리 방법을 참조
                        placeholder: 'choose a state'
                    }
                },
                numberBox: {
                    defaultProperties: {
                    }
                },
                textArea: {
                    defaultProperties:{
                    }
                },
                checkBox: {
                    defaultProperties: {
                    }
                },
                radio: {
                    defaultProperties: {
                    }
                },
                dateBox: {
                    defaultProperties: {
                        //valueFormat: '%Y-%m-%d',
                    	//iconMarginLeft: 1, //input과 calendar icon 사이 간격 px
                        localeMask: true,
                        calendarConfig: {close: true}
                    }
                },
                timeBox: {
                    defaultProperties: {
                        //iconMarginLeft: 1 //input과 spin buttons 사이 간격 px
                    }
                },
                monthBox: {
                    defaultProperties: {
                    }
                },
                datetimeBox: {
                    defaultProperties: {
                    	//valueFormat: '%Y-%m-%d %H:%M:%S',
                        //iconMarginLeft : 1 //input과 calendar icon 사이 간격 px
                    }
                },
                fromtodateBox: {
                    defaultProperties: {
                    	//valueFormat: '%Y-%m-%d',
                    	//separator: '~',
                        //iconMarginLeft : 1 //input과 calendar icon 사이 간격 px
                    }
                },
                popupTextBox : {
                    defaultProperties:{
                        useHiddenValue: true
                    }
                },
                slideMenu: {
                    defaultProperties: {
                        onlyOneTopOpen: true,
                        defaultOpenTopIndex: 0,
                        fields: {
                            rootValue: null,
                            id: 'menuId',
                            parentId: 'parentMenuId',
                            label: 'name',
                            order: 'seq'
                        }
                    }
                },
                messageBox: {
                    type: 'Rui.ui.MessageBox'
                },
                tabView: {
                    defaultProperties: {
                    }
                },
                treeView: {
                    defaultProperties: {
                        fields: {
                            rootValue: null,
                            id: 'nodeId',
                            parentId: 'parentNodeId',
                            label: 'name',
                            order: 'seq'
                        }
                    }
                },
                calendar: {
                    defaultProperties: {
                        navigator: true
                    }
                },
                gridPanel: {
                    defaultProperties: {
                        //autoWidth: false,
                        clickToEdit: false,
                        editable: true,
                        isGuide: true,
                        rendererConfig: true,
//                        excelType: 'json'
                        	excelType: 'html'
                    }
                },
                grid: {
                    defaultProperties: {
                    },
                    excelDownLoadUrl: contextPath + '/excelDownload.jsp'
                    //excelDownLoadUrl: contextPath + ruiRootPath + '/plugins/ui/grid/excelDownload.jsp'
                },
                gridScroller: {
                    defaultProperties: {
                    }
                },
                treeGrid: {
                    defaultProperties: {
                        defaultOpenTopIndex: 0,
                        fields: {
                            depthId: 'depth'
                        }
                    }
                },
                pager: {
                    defaultProperties: {
                        /* DevOn 4.0 
                        pageSizeFieldName: 'devonRowSize',
                        viewPageStartRowIndexFieldName: 'devonTargetRow',
                        */
                        /* DevOn 3.0 */
                        pageSizeFieldName: 'NUMBER_OF_ROWS_OF_PAGE',
                        viewPageStartRowIndexFieldName: 'targetRow',
                        
                        sortQueryFieldName: 'devonOrderBy'
                    }
                },
                headerContextMenu: {
                },
                notificationManager: {
                    defaultProperties: {
                    }
                },
                api: {
                    showDetail: true
                }
            }
        ,
        project:
            {
        }
    };

    // 모든 에러 report함.
    Rui.util.LEvent.throwErrors = true;

    Rui.BLANK_IMAGE_URL = '/resources/images/default/s.gif';
    
    Rui.onReady(function() {
        /*
         * config 관련 이벤트 탑재
         */
         var config = Rui.getConfig();
         var provider = config.getProvider();
         provider.on('stateChanged', function(e) {
             if (e.key == '$.core.defaultLocale') {
                 Rui.getMessageManager().setLocale(e.value[0]);
             }
         });
         
         Rui.noticeDebug();
    });

    if(Rui.ui && Rui.ui.grid && Rui.ui.grid.LColumnModel) {
        Rui.ui.grid.LColumnModel.rendererMapper['date'] = Rui.util.LRenderer.dateRenderer('%x');
        Rui.ui.grid.LColumnModel.rendererMapper['time'] = Rui.util.LRenderer.timeRenderer();
        Rui.ui.grid.LColumnModel.rendererMapper['money'] = Rui.util.LRenderer.moneyRenderer();
        Rui.ui.grid.LColumnModel.rendererMapper['number'] = Rui.util.LRenderer.numberRenderer();
        Rui.ui.grid.LColumnModel.rendererMapper['rate'] = Rui.util.LRenderer.rateRenderer();
        Rui.ui.grid.LColumnModel.rendererMapper['popup'] = Rui.util.LRenderer.popupRenderer();
    }

    //아래는 lMultiCombo의 '선택하세요'메시지 다국어 처리이나, 다국어처리를 위한 MessageManager 로딩 시간때문에 사용할수 없다.
    //아래를 프로젝트 공통으로 옮길 경우 LCombo의 emptyMessage에 준하는 LMultiCombo의 placeholder를 사용할 수 있다.
    //Rui.getConfig().set('$.ext.multicombo.defaultProperties.placeholder', Rui.getMessageManager().get('$.base.msg108'));
    
})();

