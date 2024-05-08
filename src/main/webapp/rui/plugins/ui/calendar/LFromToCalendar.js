/*
 * @(#) rui plugin
 * build version : 2.4 Release $Revision: 19574 $
 *  
 * Copyright ⓒ LG CNS, Inc. All rights reserved.
 *
 * devon@lgcns.com
 * http://www.dev-on.com
 *
 * Do Not Erase This Comment!!! (이 주석문을 지우지 말것)
 *
 * rui/license.txt를 반드시 읽어보고 사용하시기 바랍니다. License.txt파일은 절대로 삭제하시면 않됩니다. 
 *
 * 1. 사내 사용시 KAMS를 통해 요청하여 사용허가를 받으셔야 소프트웨어 라이센스 계약서에 동의하는 것으로 간주됩니다.
 * 2. DevOn RUI가 포함된 제품을 판매하실 경우에도 KAMS를 통해 요청하여 사용허가를 받으셔야 합니다.
 * 3. KAMS를 통해 사용허가를 받지 않은 경우 소프트웨어 라이센스 계약을 위반한 것으로 간주됩니다.
 * 4. 별도로 판매될 경우는 LGCNS의 소프트웨어 판매정책을 따릅니다. (KAMS에 문의 바랍니다.)
 *
 * (주의!) 원저자의 허락없이 재배포 할 수 없으며
 * LG CNS 외부로의 유출을 하여서는 안 된다.
 */
/**
 * LFromToCalendar
 * @plugin
 * @namespace Rui.ui.calendar
 * @class LFromToCalendar
 * @constructor LFromToCalendar
 * @param {Object} config The intial LFromToCalendar.
 */
Rui.ui.calendar.LFromToCalendar = function(config) {
    Rui.ui.calendar.LFromToCalendar.superclass.constructor.call(this, config);





    this.createEvent('select');
};
Rui.extend(Rui.ui.calendar.LFromToCalendar, Rui.ui.LPanel, {






    otype: 'Rui.ui.form.LFromToCalendar',






    CSS_BASE: 'L-fromtocalendar',







    doRender: function(container) {
        Rui.ui.calendar.LFromToCalendar.superclass.doRender.call(this, container);
        Rui.util.LDom.addClass(this.element, 'L-fromtocalendar-panel');
        Rui.util.LDom.setStyle(this.element, 'z-index', 999);
        this._insertBody('');
    },







    afterRender: function(container) {
        Rui.ui.calendar.LFromToCalendar.superclass.afterRender.call(this, container);

        var calContainerEl = Rui.get(document.createElement('div')),
            fromCalendarEl = Rui.get(document.createElement('div')),
            toCalendarEl = Rui.get(document.createElement('div'));
        calContainerEl.appendChild(fromCalendarEl);
        calContainerEl.appendChild(toCalendarEl);

        calContainerEl.addClass('L-fromtocalendar-inner');
        fromCalendarEl.addClass('L-fromtocalendar-from');
        toCalendarEl.addClass('L-fromtocalendar-to');

        Rui.get(this.body).appendChild(calContainerEl);

        this.setHeader(Rui.getMessageManager().get('$.ext.msg020'));

        var fromCalendar = new Rui.ui.calendar.LCalendar({
        	id: fromCalendarEl.id,
        	title: Rui.getMessageManager().get('$.ext.msg018')
        });
        fromCalendar.selectEvent.on(this.onStartCalendarSelected, this, true);
        fromCalendar.render();
        this.fromCalendar = fromCalendar;

        var toCalendar = new Rui.ui.calendar.LCalendar({
        	id: toCalendarEl.id,
        	title: Rui.getMessageManager().get('$.ext.msg019')
        });
        toCalendar.selectEvent.on(this.onEndCalendarSelected, this, true);
        toCalendar.render();
        this.toCalendar = toCalendar;

        this.el.show();
        this.show();
    },







    onStartCalendarSelected: function(e){
        this.fireEvent('select', {
            target: this,
            start: e.date
        });
    },







    onEndCalendarSelected: function(e){
        this.fireEvent('select', {
            target: this,
            end: e.date
        });
    },






    clear: function(){
    	if(this.fromCalendar)
    		this.fromCalendar.clear();
    	if(this.toCalendar)
    		this.toCalendar.clear();
    },









    select: function(startDate, endDate, fireEvent){
    	if(this.fromCalendar && startDate){
    		this.fromCalendar.select(startDate, fireEvent);
    		this.fromCalendar.cfg.setProperty('pagedate', startDate);
    		this.fromCalendar.render();
    	}
    	if(this.toCalendar && endDate){
    		this.toCalendar.select(endDate, fireEvent);
    		this.toCalendar.cfg.setProperty('pagedate', endDate);
    		this.toCalendar.render();
    	}
    }
});
