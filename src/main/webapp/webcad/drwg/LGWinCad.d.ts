/// <reference path="typings/hammerjs.d.ts" />
declare namespace U1.UIControls {
    interface IBiBase {
        Pause(): any;
        Resume(): any;
        UnBind(): any;
        Update(): any;
    }
    abstract class BiBase<T extends HTMLElement> implements IBiBase {
        Source: INotifyPropertyChanged;
        Target: T;
        private old_display;
        private old_pointerEvents;
        protected isUpdating: boolean;
        IsPasued: any;
        IsEnable: boolean;
        IsVisible: boolean;
        IsEnabledSource: string;
        IsVisibleSource: string;
        Pause(): this;
        Resume(): this;
        UnBind(): this;
        Update(): this;
        protected OnUpdate(): void;
        setSource(source: INotifyPropertyChanged): this;
        setTarget(target: T): this;
        setIsEnableSource(prop: string): this;
        setIsVisibleSource(prop: string): this;
        setIsEnable(isEnable: boolean): this;
        setIsVisible(isVisible: boolean): this;
        private CallOnPropertyChanged(sender, prop);
        protected OnPropertyChanged(sender: any, prop: string): void;
        static GetOrSetChild<T extends HTMLElement>(ctr: {
            new (): T;
        }, container: HTMLElement, tag: string): T;
    }
    class BiCollection implements IBiBase {
        Children: IBiBase[];
        Pause(): void;
        Resume(): void;
        UnBind(): void;
        Update(): void;
    }
}
declare namespace U1.UIControls {
    class BiCommand<T extends HTMLElement> extends BiBase<T> {
        private _command;
        Command: UCommand;
        Content: any;
        ContentSource: string;
        ContentRenderer: (container: T, content: any) => any;
        CommandSource: string;
        CommandArg: any;
        CommandArgGetter: (sender: this) => any;
        setTarget(target: T): this;
        setContentRenderer(renderer: (container: T, content: any) => any): this;
        setContentSource(content: string): this;
        setCommandSource(source: string): this;
        setCommand(command: UCommand): this;
        setCommandArgumentGetter(argFunc: (sender: this) => any): this;
        protected OnPropertyChanged(sender: any, prop: string): void;
        protected OnUpdate(): void;
        private UpdateCommand();
        private UpdateContent();
        UnBind(): this;
    }
    class BiButton extends BiCommand<HTMLButtonElement> {
    }
}
declare namespace U1.UIControls {
    class BiCheckBox extends BiBase<HTMLInputElement> {
        IsChecked: boolean;
        ContentRenderer: (container: HTMLInputElement, isChecked: boolean) => any;
        IsCheckedSource: string;
        setTarget(target: HTMLInputElement): this;
        setContentRenderer(renderer: (container: HTMLInputElement) => any): this;
        setIsChecked(value: boolean): this;
        setIsCheckedSource(source: string): this;
        protected OnPropertyChanged(sender: any, prop: string): void;
        private OnTargetChanged(target, ev);
        protected OnUpdate(): void;
        UnBind(): this;
        private UpdateIsChecked();
    }
}
declare namespace U1.UIControls {
    class BiColorPicker extends BiBase<HTMLInputElement> {
        ColorSource: string;
        Color: Color;
        UseAlpha: boolean;
        ContentRenderer: (container: HTMLLabelElement, content: any) => any;
        setTarget(target: HTMLInputElement): this;
        setUserAlpha(useAlpha: boolean): this;
        setColorSource(content: string): this;
        private OnColorChange(a, r, g, b);
        protected OnPropertyChanged(sender: any, prop: string): void;
        protected OnUpdate(): void;
        private UpdateColor();
        UnBind(): this;
    }
}
declare namespace U1.UIControls {
    class BiComboBox<T> extends BiBase<HTMLSelectElement> {
        private _oldSelectedItem;
        private _oldItms;
        private _itemsMap;
        private _isItemsUpdated;
        SelectedItem: T;
        Items: T[];
        ItemRenderer: (itemcontainer: HTMLSelectElement | HTMLOptionElement, item: T) => any;
        SelectedItemSource: string;
        ItemsSource: string;
        setTarget(target: HTMLSelectElement): this;
        setItemRenderer(renderer: (itemcontainer: HTMLSelectElement | HTMLOptionElement, item: T) => any): this;
        setSelectedItemSource(source: string): this;
        setItemsSource(source: string): this;
        setItems(items: T[]): this;
        protected OnPropertyChanged(sender: any, prop: string): void;
        private OnTargetChanged(target, ev);
        protected OnUpdate(): void;
        UnBind(): this;
        private UpdateSelectedItem();
        private UpdateItems();
    }
}
declare namespace U1.UIControls {
    class BiContent<T> extends BiBase<HTMLElement> {
        Content: T;
        ContentSource: string;
        ContentRenderer: (container: HTMLElement, content: T) => any;
        setContentRenderer(renderer: (container: HTMLElement, content: T) => any): this;
        setContentSource(content: string): this;
        protected OnPropertyChanged(sender: any, prop: string): void;
        protected OnUpdate(): void;
        private UpdateContent();
        UnBind(): this;
    }
}
declare namespace U1.UIControls {
    class BiDataGrid<T> extends BiBase<HTMLTableElement> {
        private row_elements;
        private head_elements;
        private sort_column;
        private sort_reverse;
        SelectedItem: T;
        Items: T[];
        ItemRenderer: (itemcontainer: HTMLTableRowElement, item: T, isSelected: boolean) => any;
        HeadRenderer: (headcontainer: HTMLTableHeaderCellElement, head: any, sortColumn: boolean) => any;
        ItemsSorter: (items: T[], sortColumn: string) => T[];
        Heads: any[];
        SelectedItemSource: string;
        ItemsSource: string;
        SortColumn: any;
        setTarget(target: HTMLTableElement): this;
        setItemRenderer(renderer: (itemcontainer: HTMLTableRowElement, item: T, isSelected: boolean) => any): this;
        setHeadRenderer(renderer: (headcontainer: HTMLTableHeaderCellElement, head: any, sortColumn: boolean) => any): this;
        setItemsSorter(renderer: (items: T[], sortColumn: any) => T[]): this;
        setSelectedItemSource(source: string): this;
        setItemsSource(source: string): this;
        setHeads(heads: string[]): this;
        protected OnPropertyChanged(sender: any, prop: string): void;
        private OnItemClick(ev);
        protected OnUpdate(): void;
        UnBind(): this;
        private UpdateSelectedItem();
        private UpdateItems(isChanged?);
        private UpdatHeads();
    }
}
declare namespace U1.UIControls {
    class BiDropdown<T> extends BiBase<HTMLDivElement> {
        private lielements;
        private itemBinders;
        SelectedItem: T;
        Items: T[];
        ItemRenderer: (itemcontainer: HTMLLIElement, item: T, isSelected: boolean) => BiBase<HTMLElement>;
        HeadRenderer: (head: HTMLElement, item: T) => any;
        SelectedItemSource: string;
        ItemsSource: string;
        setTarget(target: HTMLDivElement): this;
        setItemRenderer(renderer: (itemcontainer: HTMLLIElement, item: T, isSelected: boolean) => BiBase<HTMLElement>): this;
        setHeadRenderer(renderer: (head: HTMLElement, item: T) => any): this;
        setSelectedItemSource(source: string): this;
        setItemsSource(source: string): this;
        protected OnPropertyChanged(sender: any, prop: string): void;
        private OnItemClick(ev);
        protected OnUpdate(): void;
        UnBind(): this;
        private UpdateSelectedItem();
        private UpdateItems();
    }
}
declare namespace U1.UIControls {
    class BiEnable extends BiBase<HTMLElement> {
    }
}
declare namespace U1.UIControls {
    class BiItemsControl<T> extends BiBase<HTMLUListElement> {
        private item_edits;
        Items: T[];
        ItemRenderer: (itemcontainer: HTMLLIElement, item: T) => any;
        ItemsSource: string;
        ItemClickHandler: (item: T) => any;
        setTarget(target: HTMLUListElement): this;
        setItemRenderer(renderer: (itemcontainer: HTMLLIElement, item: T) => any): this;
        setItemsSource(source: string): this;
        setClickHandler(handler: (item: T) => any): this;
        protected OnPropertyChanged(sender: any, prop: string): void;
        private OnItemClick(ev);
        protected OnUpdate(): void;
        UnBind(): this;
        private UpdateItems();
    }
}
declare namespace U1.UIControls {
    class BiLabel extends BiBase<HTMLLabelElement> {
        Content: any;
        ContentSource: string;
        ContentRenderer: (container: HTMLLabelElement, content: any) => any;
        setTarget(target: HTMLLabelElement): this;
        setContentRenderer(renderer: (container: HTMLLabelElement, content: any) => any): this;
        setContentSource(content: string): this;
        protected OnPropertyChanged(sender: any, prop: string): void;
        protected OnUpdate(): void;
        private UpdateContent();
        UnBind(): this;
    }
}
declare namespace U1.UIControls {
    class BiListBox<T> extends BiBase<HTMLUListElement> {
        private lielements;
        SelectedItem: T;
        Items: T[];
        ItemRenderer: (itemcontainer: HTMLLIElement, item: T, isSelected: boolean) => any;
        SelectedItemSource: string;
        ItemsSource: string;
        setTarget(target: HTMLUListElement): this;
        setItemRenderer(renderer: (itemcontainer: HTMLLIElement, item: T, isSelected: boolean) => any): this;
        setSelectedItemSource(source: string): this;
        setItemsSource(source: string): this;
        protected OnPropertyChanged(sender: any, prop: string): void;
        private OnItemClick(ev);
        protected OnUpdate(): void;
        UnBind(): this;
        private UpdateSelectedItem();
        private UpdateItems();
    }
}
declare namespace U1.UIControls {
    class BiNumber extends BiBase<HTMLInputElement> {
        ValueSource: string;
        Value: number;
        ChangeAfterEnter: boolean;
        setTarget(target: HTMLInputElement): this;
        setValueSource(content: string): this;
        setChangeAfterEnter(value: boolean): this;
        OnKeyUp(event: KeyboardEvent): void;
        private OnTextChange(text);
        protected OnPropertyChanged(sender: any, prop: string): void;
        protected OnUpdate(): void;
        private UpdateValue();
        UnBind(): this;
    }
}
declare namespace U1.UIControls {
    class BiPropertyEdit extends BiBase<HTMLTableRowElement> {
        protected input: HTMLInputElement;
        protected label: HTMLLabelElement;
        protected text: string;
        Property: UPropertyBase;
        ContentRenderer: (container: HTMLTableRowElement) => any;
        setContentRenderer(renderer: (container: HTMLTableRowElement) => any): this;
        setSource(source: UPropertyBase): this;
        protected OnPropertyChanged(sender: any, prop: string): void;
        protected OnUpdate(): this;
        UnBind(): this;
        OnChange(event: Event): void;
        OnKeyUp(event: KeyboardEvent): void;
        private OnTextChange(text);
    }
    class BiPropertyCheckEdit extends BiPropertyEdit {
        private checked;
        Property: UPropBool;
        ContentRenderer: (container: HTMLTableRowElement) => any;
        setContentRenderer(renderer: (container: HTMLTableRowElement) => any): this;
        setSource(source: UPropBool): this;
        protected OnPropertyChanged(sender: any, prop: string): void;
        protected OnUpdate(): this;
        UnBind(): this;
        OnChange(event: Event): void;
        private OnCheckChange(checked);
    }
}
declare namespace U1.UIControls {
    class BiPropertyGrid extends BiBase<HTMLTableElement> {
        Items: UPropertyBase[];
        private PropertyEdits;
        ItemsSource: string;
        setItemsSource(source: string): this;
        protected OnPropertyChanged(sender: any, prop: string): void;
        protected OnUpdate(): void;
        UnBind(): this;
        private UpdateItems();
        Pause(): this;
        Resume(): this;
    }
}
declare namespace U1.UIControls {
    class BiTextArea extends BiBase<HTMLTextAreaElement> {
        TextSource: string;
        Text: string;
        AfterTextChangedFunc: (binder: BiTextArea, text: string) => any;
        setTarget(target: HTMLTextAreaElement): this;
        setTextSource(content: string): this;
        setAfterTextChangedFunc(func: (binder: BiTextArea, text: string) => any): this;
        private OnTargetChanged(target, ev);
        protected OnPropertyChanged(sender: any, prop: string): void;
        protected OnUpdate(): void;
        private UpdateText();
        UnBind(): this;
    }
}
declare namespace U1.UIControls {
    class BiTextBox extends BiBase<HTMLInputElement> {
        TextSource: string;
        Text: string;
        AfterTextChangedFunc: (binder: BiTextBox, text: string) => any;
        setTarget(target: HTMLInputElement): this;
        setTextSource(content: string): this;
        setText(value: string): this;
        setAfterTextChangedFunc(func: (binder: BiTextBox, text: string) => any): this;
        OnKeyUp(event: KeyboardEvent): void;
        private OnTextChange(text);
        protected OnPropertyChanged(sender: any, prop: string): void;
        protected OnUpdate(): void;
        private UpdateText();
        UnBind(): this;
    }
}
declare namespace U1.UIControls {
    class BiVisibility extends BiBase<HTMLElement> {
    }
}
/**
 * @namespace Top level namespace for collections, a TypeScript data structure library.
 */
declare module collections {
    /**
    * Function signature for comparing
    * <0 means a is smaller
    * = 0 means they are equal
    * >0 means a is larger
    */
    interface ICompareFunction<T> {
        (a: T, b: T): number;
    }
    /**
    * Function signature for checking equality
    */
    interface IEqualsFunction<T> {
        (a: T, b: T): boolean;
    }
    /**
    * Function signature for Iterations. Return false to break from loop
    */
    interface ILoopFunction<T> {
        (a: T): boolean;
    }
    /**
     * Default function to compare element order.
     * @function
     */
    function defaultCompare<T>(a: T, b: T): number;
    /**
     * Default function to test equality.
     * @function
     */
    function defaultEquals<T>(a: T, b: T): boolean;
    /**
     * Default function to convert an object to a string.
     * @function
     */
    function defaultToString(item: any): string;
    /**
    * Joins all the properies of the object using the provided join string
    */
    function makeString<T>(item: T, join?: string): string;
    /**
     * Checks if the given argument is a function.
     * @function
     */
    function isFunction(func: any): boolean;
    /**
     * Checks if the given argument is undefined.
     * @function
     */
    function isUndefined(obj: any): boolean;
    /**
     * Checks if the given argument is a string.
     * @function
     */
    function isString(obj: any): boolean;
    /**
     * Reverses a compare function.
     * @function
     */
    function reverseCompareFunction<T>(compareFunction: ICompareFunction<T>): ICompareFunction<T>;
    /**
     * Returns an equal function given a compare function.
     * @function
     */
    function compareToEquals<T>(compareFunction: ICompareFunction<T>): IEqualsFunction<T>;
    /**
     * @namespace Contains various functions for manipulating arrays.
     */
    module arrays {
        /**
         * Returns the position of the first occurrence of the specified item
         * within the specified array.
         * @param {*} array the array in which to search the element.
         * @param {Object} item the element to search.
         * @param {function(Object,Object):boolean=} equalsFunction optional function used to
         * check equality between 2 elements.
         * @return {number} the position of the first occurrence of the specified element
         * within the specified array, or -1 if not found.
         */
        function indexOf<T>(array: T[], item: T, equalsFunction?: collections.IEqualsFunction<T>): number;
        /**
         * Returns the position of the last occurrence of the specified element
         * within the specified array.
         * @param {*} array the array in which to search the element.
         * @param {Object} item the element to search.
         * @param {function(Object,Object):boolean=} equalsFunction optional function used to
         * check equality between 2 elements.
         * @return {number} the position of the last occurrence of the specified element
         * within the specified array or -1 if not found.
         */
        function lastIndexOf<T>(array: T[], item: T, equalsFunction?: collections.IEqualsFunction<T>): number;
        /**
         * Returns true if the specified array contains the specified element.
         * @param {*} array the array in which to search the element.
         * @param {Object} item the element to search.
         * @param {function(Object,Object):boolean=} equalsFunction optional function to
         * check equality between 2 elements.
         * @return {boolean} true if the specified array contains the specified element.
         */
        function contains<T>(array: T[], item: T, equalsFunction?: collections.IEqualsFunction<T>): boolean;
        /**
         * Removes the first ocurrence of the specified element from the specified array.
         * @param {*} array the array in which to search element.
         * @param {Object} item the element to search.
         * @param {function(Object,Object):boolean=} equalsFunction optional function to
         * check equality between 2 elements.
         * @return {boolean} true if the array changed after this call.
         */
        function remove<T>(array: T[], item: T, equalsFunction?: collections.IEqualsFunction<T>): boolean;
        /**
         * Returns the number of elements in the specified array equal
         * to the specified object.
         * @param {Array} array the array in which to determine the frequency of the element.
         * @param {Object} item the element whose frequency is to be determined.
         * @param {function(Object,Object):boolean=} equalsFunction optional function used to
         * check equality between 2 elements.
         * @return {number} the number of elements in the specified array
         * equal to the specified object.
         */
        function frequency<T>(array: T[], item: T, equalsFunction?: collections.IEqualsFunction<T>): number;
        /**
         * Returns true if the two specified arrays are equal to one another.
         * Two arrays are considered equal if both arrays contain the same number
         * of elements, and all corresponding pairs of elements in the two
         * arrays are equal and are in the same order.
         * @param {Array} array1 one array to be tested for equality.
         * @param {Array} array2 the other array to be tested for equality.
         * @param {function(Object,Object):boolean=} equalsFunction optional function used to
         * check equality between elemements in the arrays.
         * @return {boolean} true if the two arrays are equal
         */
        function equals<T>(array1: T[], array2: T[], equalsFunction?: collections.IEqualsFunction<T>): boolean;
        /**
         * Returns shallow a copy of the specified array.
         * @param {*} array the array to copy.
         * @return {Array} a copy of the specified array
         */
        function copy<T>(array: T[]): T[];
        /**
         * Swaps the elements at the specified positions in the specified array.
         * @param {Array} array The array in which to swap elements.
         * @param {number} i the index of one element to be swapped.
         * @param {number} j the index of the other element to be swapped.
         * @return {boolean} true if the array is defined and the indexes are valid.
         */
        function swap<T>(array: T[], i: number, j: number): boolean;
        function toString<T>(array: T[]): string;
        /**
         * Executes the provided function once for each element present in this array
         * starting from index 0 to length - 1.
         * @param {Array} array The array in which to iterate.
         * @param {function(Object):*} callback function to execute, it is
         * invoked with one argument: the element value, to break the iteration you can
         * optionally return false.
         */
        function forEach<T>(array: T[], callback: (item: T) => boolean): void;
    }
    interface ILinkedListNode<T> {
        element: T;
        next: ILinkedListNode<T>;
    }
    class LinkedList<T> {
        /**
        * First node in the list
        * @type {Object}
        * @private
        */
        firstNode: ILinkedListNode<T>;
        /**
        * Last node in the list
        * @type {Object}
        * @private
        */
        private lastNode;
        /**
        * Number of elements in the list
        * @type {number}
        * @private
        */
        private nElements;
        /**
        * Creates an empty Linked List.
        * @class A linked list is a data structure consisting of a group of nodes
        * which together represent a sequence.
        * @constructor
        */
        constructor();
        /**
        * Adds an element to this list.
        * @param {Object} item element to be added.
        * @param {number=} index optional index to add the element. If no index is specified
        * the element is added to the end of this list.
        * @return {boolean} true if the element was added or false if the index is invalid
        * or if the element is undefined.
        */
        add(item: T, index?: number): boolean;
        /**
        * Returns the first element in this list.
        * @return {*} the first element of the list or undefined if the list is
        * empty.
        */
        first(): T;
        /**
        * Returns the last element in this list.
        * @return {*} the last element in the list or undefined if the list is
        * empty.
        */
        last(): T;
        /**
         * Returns the element at the specified position in this list.
         * @param {number} index desired index.
         * @return {*} the element at the given index or undefined if the index is
         * out of bounds.
         */
        elementAtIndex(index: number): T;
        /**
         * Returns the index in this list of the first occurrence of the
         * specified element, or -1 if the List does not contain this element.
         * <p>If the elements inside this list are
         * not comparable with the === operator a custom equals function should be
         * provided to perform searches, the function must receive two arguments and
         * return true if they are equal, false otherwise. Example:</p>
         *
         * <pre>
         * var petsAreEqualByName = function(pet1, pet2) {
         *  return pet1.name === pet2.name;
         * }
         * </pre>
         * @param {Object} item element to search for.
         * @param {function(Object,Object):boolean=} equalsFunction Optional
         * function used to check if two elements are equal.
         * @return {number} the index in this list of the first occurrence
         * of the specified element, or -1 if this list does not contain the
         * element.
         */
        indexOf(item: T, equalsFunction?: IEqualsFunction<T>): number;
        /**
           * Returns true if this list contains the specified element.
           * <p>If the elements inside the list are
           * not comparable with the === operator a custom equals function should be
           * provided to perform searches, the function must receive two arguments and
           * return true if they are equal, false otherwise. Example:</p>
           *
           * <pre>
           * var petsAreEqualByName = function(pet1, pet2) {
           *  return pet1.name === pet2.name;
           * }
           * </pre>
           * @param {Object} item element to search for.
           * @param {function(Object,Object):boolean=} equalsFunction Optional
           * function used to check if two elements are equal.
           * @return {boolean} true if this list contains the specified element, false
           * otherwise.
           */
        contains(item: T, equalsFunction?: IEqualsFunction<T>): boolean;
        /**
         * Removes the first occurrence of the specified element in this list.
         * <p>If the elements inside the list are
         * not comparable with the === operator a custom equals function should be
         * provided to perform searches, the function must receive two arguments and
         * return true if they are equal, false otherwise. Example:</p>
         *
         * <pre>
         * var petsAreEqualByName = function(pet1, pet2) {
         *  return pet1.name === pet2.name;
         * }
         * </pre>
         * @param {Object} item element to be removed from this list, if present.
         * @return {boolean} true if the list contained the specified element.
         */
        remove(item: T, equalsFunction?: IEqualsFunction<T>): boolean;
        /**
         * Removes all of the elements from this list.
         */
        clear(): void;
        /**
         * Returns true if this list is equal to the given list.
         * Two lists are equal if they have the same elements in the same order.
         * @param {LinkedList} other the other list.
         * @param {function(Object,Object):boolean=} equalsFunction optional
         * function used to check if two elements are equal. If the elements in the lists
         * are custom objects you should provide a function, otherwise
         * the === operator is used to check equality between elements.
         * @return {boolean} true if this list is equal to the given list.
         */
        equals(other: LinkedList<T>, equalsFunction?: IEqualsFunction<T>): boolean;
        /**
        * @private
        */
        private equalsAux(n1, n2, eqF);
        /**
         * Removes the element at the specified position in this list.
         * @param {number} index given index.
         * @return {*} removed element or undefined if the index is out of bounds.
         */
        removeElementAtIndex(index: number): T;
        /**
         * Executes the provided function once for each element present in this list in order.
         * @param {function(Object):*} callback function to execute, it is
         * invoked with one argument: the element value, to break the iteration you can
         * optionally return false.
         */
        forEach(callback: (item: T) => boolean): void;
        /**
         * Reverses the order of the elements in this linked list (makes the last
         * element first, and the first element last).
         */
        reverse(): void;
        /**
         * Returns an array containing all of the elements in this list in proper
         * sequence.
         * @return {Array.<*>} an array containing all of the elements in this list,
         * in proper sequence.
         */
        toArray(): T[];
        /**
         * Returns the number of elements in this list.
         * @return {number} the number of elements in this list.
         */
        size(): number;
        /**
         * Returns true if this list contains no elements.
         * @return {boolean} true if this list contains no elements.
         */
        isEmpty(): boolean;
        toString(): string;
        /**
         * @private
         */
        private nodeAtIndex(index);
        /**
         * @private
         */
        private createNode(item);
    }
    class Dictionary<K, V> {
        /**
         * Object holding the key-value pairs.
         * @type {Object}
         * @private
         */
        private table;
        /**
         * Number of elements in the list.
         * @type {number}
         * @private
         */
        private nElements;
        /**
         * Function used to convert keys to strings.
         * @type {function(Object):string}
         * @private
         */
        private toStr;
        /**
         * Creates an empty dictionary.
         * @class <p>Dictionaries map keys to values; each key can map to at most one value.
         * This implementation accepts any kind of objects as keys.</p>
         *
         * <p>If the keys are custom objects a function which converts keys to unique
         * strings must be provided. Example:</p>
         * <pre>
         * function petToString(pet) {
         *  return pet.name;
         * }
         * </pre>
         * @constructor
         * @param {function(Object):string=} toStrFunction optional function used
         * to convert keys to strings. If the keys aren't strings or if toString()
         * is not appropriate, a custom function which receives a key and returns a
         * unique string must be provided.
         */
        constructor(toStrFunction?: (key: K) => string);
        /**
         * Returns the value to which this dictionary maps the specified key.
         * Returns undefined if this dictionary contains no mapping for this key.
         * @param {Object} key key whose associated value is to be returned.
         * @return {*} the value to which this dictionary maps the specified key or
         * undefined if the map contains no mapping for this key.
         */
        getValue(key: K): V;
        /**
         * Associates the specified value with the specified key in this dictionary.
         * If the dictionary previously contained a mapping for this key, the old
         * value is replaced by the specified value.
         * @param {Object} key key with which the specified value is to be
         * associated.
         * @param {Object} value value to be associated with the specified key.
         * @return {*} previous value associated with the specified key, or undefined if
         * there was no mapping for the key or if the key/value are undefined.
         */
        setValue(key: K, value: V): V;
        /**
         * Removes the mapping for this key from this dictionary if it is present.
         * @param {Object} key key whose mapping is to be removed from the
         * dictionary.
         * @return {*} previous value associated with specified key, or undefined if
         * there was no mapping for key.
         */
        remove(key: K): V;
        /**
         * Returns an array containing all of the keys in this dictionary.
         * @return {Array} an array containing all of the keys in this dictionary.
         */
        keys(): K[];
        /**
         * Returns an array containing all of the values in this dictionary.
         * @return {Array} an array containing all of the values in this dictionary.
         */
        values(): V[];
        /**
        * Executes the provided function once for each key-value pair
        * present in this dictionary.
        * @param {function(Object,Object):*} callback function to execute, it is
        * invoked with two arguments: key and value. To break the iteration you can
        * optionally return false.
        */
        forEach(callback: (key: K, value: V) => any): void;
        /**
         * Returns true if this dictionary contains a mapping for the specified key.
         * @param {Object} key key whose presence in this dictionary is to be
         * tested.
         * @return {boolean} true if this dictionary contains a mapping for the
         * specified key.
         */
        containsKey(key: K): boolean;
        /**
        * Removes all mappings from this dictionary.
        * @this {collections.Dictionary}
        */
        clear(): void;
        /**
         * Returns the number of keys in this dictionary.
         * @return {number} the number of key-value mappings in this dictionary.
         */
        size(): number;
        /**
         * Returns true if this dictionary contains no mappings.
         * @return {boolean} true if this dictionary contains no mappings.
         */
        isEmpty(): boolean;
        toString(): string;
    }
    class MultiDictionary<K, V> {
        private dict;
        private equalsF;
        private allowDuplicate;
        /**
         * Creates an empty multi dictionary.
         * @class <p>A multi dictionary is a special kind of dictionary that holds
         * multiple values against each key. Setting a value into the dictionary will
         * add the value to an array at that key. Getting a key will return an array,
         * holding all the values set to that key.
         * You can configure to allow duplicates in the values.
         * This implementation accepts any kind of objects as keys.</p>
         *
         * <p>If the keys are custom objects a function which converts keys to strings must be
         * provided. Example:</p>
         *
         * <pre>
         * function petToString(pet) {
           *  return pet.name;
           * }
         * </pre>
         * <p>If the values are custom objects a function to check equality between values
         * must be provided. Example:</p>
         *
         * <pre>
         * function petsAreEqualByAge(pet1,pet2) {
           *  return pet1.age===pet2.age;
           * }
         * </pre>
         * @constructor
         * @param {function(Object):string=} toStrFunction optional function
         * to convert keys to strings. If the keys aren't strings or if toString()
         * is not appropriate, a custom function which receives a key and returns a
         * unique string must be provided.
         * @param {function(Object,Object):boolean=} valuesEqualsFunction optional
         * function to check if two values are equal.
         *
         * @param allowDuplicateValues
         */
        constructor(toStrFunction?: (key: K) => string, valuesEqualsFunction?: IEqualsFunction<V>, allowDuplicateValues?: boolean);
        /**
        * Returns an array holding the values to which this dictionary maps
        * the specified key.
        * Returns an empty array if this dictionary contains no mappings for this key.
        * @param {Object} key key whose associated values are to be returned.
        * @return {Array} an array holding the values to which this dictionary maps
        * the specified key.
        */
        getValue(key: K): V[];
        /**
         * Adds the value to the array associated with the specified key, if
         * it is not already present.
         * @param {Object} key key with which the specified value is to be
         * associated.
         * @param {Object} value the value to add to the array at the key
         * @return {boolean} true if the value was not already associated with that key.
         */
        setValue(key: K, value: V): boolean;
        /**
         * Removes the specified values from the array of values associated with the
         * specified key. If a value isn't given, all values associated with the specified
         * key are removed.
         * @param {Object} key key whose mapping is to be removed from the
         * dictionary.
         * @param {Object=} value optional argument to specify the value to remove
         * from the array associated with the specified key.
         * @return {*} true if the dictionary changed, false if the key doesn't exist or
         * if the specified value isn't associated with the specified key.
         */
        remove(key: K, value?: V): boolean;
        /**
         * Returns an array containing all of the keys in this dictionary.
         * @return {Array} an array containing all of the keys in this dictionary.
         */
        keys(): K[];
        /**
         * Returns an array containing all of the values in this dictionary.
         * @return {Array} an array containing all of the values in this dictionary.
         */
        values(): V[];
        /**
         * Returns true if this dictionary at least one value associatted the specified key.
         * @param {Object} key key whose presence in this dictionary is to be
         * tested.
         * @return {boolean} true if this dictionary at least one value associatted
         * the specified key.
         */
        containsKey(key: K): boolean;
        /**
         * Removes all mappings from this dictionary.
         */
        clear(): void;
        /**
         * Returns the number of keys in this dictionary.
         * @return {number} the number of key-value mappings in this dictionary.
         */
        size(): number;
        /**
         * Returns true if this dictionary contains no mappings.
         * @return {boolean} true if this dictionary contains no mappings.
         */
        isEmpty(): boolean;
    }
    class Heap<T> {
        /**
         * Array used to store the elements od the heap.
         * @type {Array.<Object>}
         * @private
         */
        private data;
        /**
         * Function used to compare elements.
         * @type {function(Object,Object):number}
         * @private
         */
        private compare;
        /**
         * Creates an empty Heap.
         * @class
         * <p>A heap is a binary tree, where the nodes maintain the heap property:
         * each node is smaller than each of its children and therefore a MinHeap
         * This implementation uses an array to store elements.</p>
         * <p>If the inserted elements are custom objects a compare function must be provided,
         *  at construction time, otherwise the <=, === and >= operators are
         * used to compare elements. Example:</p>
         *
         * <pre>
         * function compare(a, b) {
         *  if (a is less than b by some ordering criterion) {
         *     return -1;
         *  } if (a is greater than b by the ordering criterion) {
         *     return 1;
         *  }
         *  // a must be equal to b
         *  return 0;
         * }
         * </pre>
         *
         * <p>If a Max-Heap is wanted (greater elements on top) you can a provide a
         * reverse compare function to accomplish that behavior. Example:</p>
         *
         * <pre>
         * function reverseCompare(a, b) {
         *  if (a is less than b by some ordering criterion) {
         *     return 1;
         *  } if (a is greater than b by the ordering criterion) {
         *     return -1;
         *  }
         *  // a must be equal to b
         *  return 0;
         * }
         * </pre>
         *
         * @constructor
         * @param {function(Object,Object):number=} compareFunction optional
         * function used to compare two elements. Must return a negative integer,
         * zero, or a positive integer as the first argument is less than, equal to,
         * or greater than the second.
         */
        constructor(compareFunction?: ICompareFunction<T>);
        /**
         * Returns the index of the left child of the node at the given index.
         * @param {number} nodeIndex The index of the node to get the left child
         * for.
         * @return {number} The index of the left child.
         * @private
         */
        private leftChildIndex(nodeIndex);
        /**
         * Returns the index of the right child of the node at the given index.
         * @param {number} nodeIndex The index of the node to get the right child
         * for.
         * @return {number} The index of the right child.
         * @private
         */
        private rightChildIndex(nodeIndex);
        /**
         * Returns the index of the parent of the node at the given index.
         * @param {number} nodeIndex The index of the node to get the parent for.
         * @return {number} The index of the parent.
         * @private
         */
        private parentIndex(nodeIndex);
        /**
         * Returns the index of the smaller child node (if it exists).
         * @param {number} leftChild left child index.
         * @param {number} rightChild right child index.
         * @return {number} the index with the minimum value or -1 if it doesn't
         * exists.
         * @private
         */
        private minIndex(leftChild, rightChild);
        /**
         * Moves the node at the given index up to its proper place in the heap.
         * @param {number} index The index of the node to move up.
         * @private
         */
        private siftUp(index);
        /**
         * Moves the node at the given index down to its proper place in the heap.
         * @param {number} nodeIndex The index of the node to move down.
         * @private
         */
        private siftDown(nodeIndex);
        /**
         * Retrieves but does not remove the root element of this heap.
         * @return {*} The value at the root of the heap. Returns undefined if the
         * heap is empty.
         */
        peek(): T;
        /**
         * Adds the given element into the heap.
         * @param {*} element the element.
         * @return true if the element was added or fals if it is undefined.
         */
        add(element: T): boolean;
        /**
         * Retrieves and removes the root element of this heap.
         * @return {*} The value removed from the root of the heap. Returns
         * undefined if the heap is empty.
         */
        removeRoot(): T;
        /**
         * Returns true if this heap contains the specified element.
         * @param {Object} element element to search for.
         * @return {boolean} true if this Heap contains the specified element, false
         * otherwise.
         */
        contains(element: T): boolean;
        /**
         * Returns the number of elements in this heap.
         * @return {number} the number of elements in this heap.
         */
        size(): number;
        /**
         * Checks if this heap is empty.
         * @return {boolean} true if and only if this heap contains no items; false
         * otherwise.
         */
        isEmpty(): boolean;
        /**
         * Removes all of the elements from this heap.
         */
        clear(): void;
        /**
         * Executes the provided function once for each element present in this heap in
         * no particular order.
         * @param {function(Object):*} callback function to execute, it is
         * invoked with one argument: the element value, to break the iteration you can
         * optionally return false.
         */
        forEach(callback: (item: T) => boolean): void;
    }
    class Stack<T> {
        /**
         * List containing the elements.
         * @type collections.LinkedList
         * @private
         */
        private list;
        /**
         * Creates an empty Stack.
         * @class A Stack is a Last-In-First-Out (LIFO) data structure, the last
         * element added to the stack will be the first one to be removed. This
         * implementation uses a linked list as a container.
         * @constructor
         */
        constructor();
        /**
         * Pushes an item onto the top of this stack.
         * @param {Object} elem the element to be pushed onto this stack.
         * @return {boolean} true if the element was pushed or false if it is undefined.
         */
        push(elem: T): boolean;
        /**
         * Pushes an item onto the top of this stack.
         * @param {Object} elem the element to be pushed onto this stack.
         * @return {boolean} true if the element was pushed or false if it is undefined.
         */
        add(elem: T): boolean;
        /**
         * Removes the object at the top of this stack and returns that object.
         * @return {*} the object at the top of this stack or undefined if the
         * stack is empty.
         */
        pop(): T;
        /**
         * Looks at the object at the top of this stack without removing it from the
         * stack.
         * @return {*} the object at the top of this stack or undefined if the
         * stack is empty.
         */
        peek(): T;
        /**
         * Returns the number of elements in this stack.
         * @return {number} the number of elements in this stack.
         */
        size(): number;
        /**
         * Returns true if this stack contains the specified element.
         * <p>If the elements inside this stack are
         * not comparable with the === operator, a custom equals function should be
         * provided to perform searches, the function must receive two arguments and
         * return true if they are equal, false otherwise. Example:</p>
         *
         * <pre>
         * var petsAreEqualByName (pet1, pet2) {
         *  return pet1.name === pet2.name;
         * }
         * </pre>
         * @param {Object} elem element to search for.
         * @param {function(Object,Object):boolean=} equalsFunction optional
         * function to check if two elements are equal.
         * @return {boolean} true if this stack contains the specified element,
         * false otherwise.
         */
        contains(elem: T, equalsFunction?: IEqualsFunction<T>): boolean;
        /**
         * Checks if this stack is empty.
         * @return {boolean} true if and only if this stack contains no items; false
         * otherwise.
         */
        isEmpty(): boolean;
        /**
         * Removes all of the elements from this stack.
         */
        clear(): void;
        /**
         * Executes the provided function once for each element present in this stack in
         * LIFO order.
         * @param {function(Object):*} callback function to execute, it is
         * invoked with one argument: the element value, to break the iteration you can
         * optionally return false.
         */
        forEach(callback: ILoopFunction<T>): void;
    }
    class Queue<T> {
        /**
         * List containing the elements.
         * @type collections.LinkedList
         * @private
         */
        private list;
        /**
         * Creates an empty queue.
         * @class A queue is a First-In-First-Out (FIFO) data structure, the first
         * element added to the queue will be the first one to be removed. This
         * implementation uses a linked list as a container.
         * @constructor
         */
        constructor();
        /**
         * Inserts the specified element into the end of this queue.
         * @param {Object} elem the element to insert.
         * @return {boolean} true if the element was inserted, or false if it is undefined.
         */
        enqueue(elem: T): boolean;
        /**
         * Inserts the specified element into the end of this queue.
         * @param {Object} elem the element to insert.
         * @return {boolean} true if the element was inserted, or false if it is undefined.
         */
        add(elem: T): boolean;
        /**
         * Retrieves and removes the head of this queue.
         * @return {*} the head of this queue, or undefined if this queue is empty.
         */
        dequeue(): T;
        /**
         * Retrieves, but does not remove, the head of this queue.
         * @return {*} the head of this queue, or undefined if this queue is empty.
         */
        peek(): T;
        /**
         * Returns the number of elements in this queue.
         * @return {number} the number of elements in this queue.
         */
        size(): number;
        /**
         * Returns true if this queue contains the specified element.
         * <p>If the elements inside this stack are
         * not comparable with the === operator, a custom equals function should be
         * provided to perform searches, the function must receive two arguments and
         * return true if they are equal, false otherwise. Example:</p>
         *
         * <pre>
         * var petsAreEqualByName (pet1, pet2) {
         *  return pet1.name === pet2.name;
         * }
         * </pre>
         * @param {Object} elem element to search for.
         * @param {function(Object,Object):boolean=} equalsFunction optional
         * function to check if two elements are equal.
         * @return {boolean} true if this queue contains the specified element,
         * false otherwise.
         */
        contains(elem: T, equalsFunction?: IEqualsFunction<T>): boolean;
        /**
         * Checks if this queue is empty.
         * @return {boolean} true if and only if this queue contains no items; false
         * otherwise.
         */
        isEmpty(): boolean;
        /**
         * Removes all of the elements from this queue.
         */
        clear(): void;
        /**
         * Executes the provided function once for each element present in this queue in
         * FIFO order.
         * @param {function(Object):*} callback function to execute, it is
         * invoked with one argument: the element value, to break the iteration you can
         * optionally return false.
         */
        forEach(callback: ILoopFunction<T>): void;
    }
    class PriorityQueue<T> {
        private heap;
        /**
         * Creates an empty priority queue.
         * @class <p>In a priority queue each element is associated with a "priority",
         * elements are dequeued in highest-priority-first order (the elements with the
         * highest priority are dequeued first). Priority Queues are implemented as heaps.
         * If the inserted elements are custom objects a compare function must be provided,
         * otherwise the <=, === and >= operators are used to compare object priority.</p>
         * <pre>
         * function compare(a, b) {
         *  if (a is less than b by some ordering criterion) {
         *     return -1;
         *  } if (a is greater than b by the ordering criterion) {
         *     return 1;
         *  }
         *  // a must be equal to b
         *  return 0;
         * }
         * </pre>
         * @constructor
         * @param {function(Object,Object):number=} compareFunction optional
         * function used to compare two element priorities. Must return a negative integer,
         * zero, or a positive integer as the first argument is less than, equal to,
         * or greater than the second.
         */
        constructor(compareFunction?: ICompareFunction<T>);
        /**
         * Inserts the specified element into this priority queue.
         * @param {Object} element the element to insert.
         * @return {boolean} true if the element was inserted, or false if it is undefined.
         */
        enqueue(element: T): boolean;
        /**
         * Inserts the specified element into this priority queue.
         * @param {Object} element the element to insert.
         * @return {boolean} true if the element was inserted, or false if it is undefined.
         */
        add(element: T): boolean;
        /**
         * Retrieves and removes the highest priority element of this queue.
         * @return {*} the the highest priority element of this queue,
         *  or undefined if this queue is empty.
         */
        dequeue(): T;
        /**
         * Retrieves, but does not remove, the highest priority element of this queue.
         * @return {*} the highest priority element of this queue, or undefined if this queue is empty.
         */
        peek(): T;
        /**
         * Returns true if this priority queue contains the specified element.
         * @param {Object} element element to search for.
         * @return {boolean} true if this priority queue contains the specified element,
         * false otherwise.
         */
        contains(element: T): boolean;
        /**
         * Checks if this priority queue is empty.
         * @return {boolean} true if and only if this priority queue contains no items; false
         * otherwise.
         */
        isEmpty(): boolean;
        /**
         * Returns the number of elements in this priority queue.
         * @return {number} the number of elements in this priority queue.
         */
        size(): number;
        /**
         * Removes all of the elements from this priority queue.
         */
        clear(): void;
        /**
         * Executes the provided function once for each element present in this queue in
         * no particular order.
         * @param {function(Object):*} callback function to execute, it is
         * invoked with one argument: the element value, to break the iteration you can
         * optionally return false.
         */
        forEach(callback: ILoopFunction<T>): void;
    }
    class Set<T> {
        private dictionary;
        /**
         * Creates an empty set.
         * @class <p>A set is a data structure that contains no duplicate items.</p>
         * <p>If the inserted elements are custom objects a function
         * which converts elements to strings must be provided. Example:</p>
         *
         * <pre>
         * function petToString(pet) {
         *  return pet.name;
         * }
         * </pre>
         *
         * @constructor
         * @param {function(Object):string=} toStringFunction optional function used
         * to convert elements to strings. If the elements aren't strings or if toString()
         * is not appropriate, a custom function which receives a onject and returns a
         * unique string must be provided.
         */
        constructor(toStringFunction?: (item: T) => string);
        /**
         * Returns true if this set contains the specified element.
         * @param {Object} element element to search for.
         * @return {boolean} true if this set contains the specified element,
         * false otherwise.
         */
        contains(element: T): boolean;
        /**
         * Adds the specified element to this set if it is not already present.
         * @param {Object} element the element to insert.
         * @return {boolean} true if this set did not already contain the specified element.
         */
        add(element: T): boolean;
        /**
         * Performs an intersecion between this an another set.
         * Removes all values that are not present this set and the given set.
         * @param {collections.Set} otherSet other set.
         */
        intersection(otherSet: Set<T>): void;
        /**
         * Performs a union between this an another set.
         * Adds all values from the given set to this set.
         * @param {collections.Set} otherSet other set.
         */
        union(otherSet: Set<T>): void;
        /**
         * Performs a difference between this an another set.
         * Removes from this set all the values that are present in the given set.
         * @param {collections.Set} otherSet other set.
         */
        difference(otherSet: Set<T>): void;
        /**
         * Checks whether the given set contains all the elements in this set.
         * @param {collections.Set} otherSet other set.
         * @return {boolean} true if this set is a subset of the given set.
         */
        isSubsetOf(otherSet: Set<T>): boolean;
        /**
         * Removes the specified element from this set if it is present.
         * @return {boolean} true if this set contained the specified element.
         */
        remove(element: T): boolean;
        /**
         * Executes the provided function once for each element
         * present in this set.
         * @param {function(Object):*} callback function to execute, it is
         * invoked with one arguments: the element. To break the iteration you can
         * optionally return false.
         */
        forEach(callback: ILoopFunction<T>): void;
        /**
         * Returns an array containing all of the elements in this set in arbitrary order.
         * @return {Array} an array containing all of the elements in this set.
         */
        toArray(): T[];
        /**
         * Returns true if this set contains no elements.
         * @return {boolean} true if this set contains no elements.
         */
        isEmpty(): boolean;
        /**
         * Returns the number of elements in this set.
         * @return {number} the number of elements in this set.
         */
        size(): number;
        /**
         * Removes all of the elements from this set.
         */
        clear(): void;
        toString(): string;
    }
    class Bag<T> {
        private toStrF;
        private dictionary;
        private nElements;
        /**
         * Creates an empty bag.
         * @class <p>A bag is a special kind of set in which members are
         * allowed to appear more than once.</p>
         * <p>If the inserted elements are custom objects a function
         * which converts elements to unique strings must be provided. Example:</p>
         *
         * <pre>
         * function petToString(pet) {
         *  return pet.name;
         * }
         * </pre>
         *
         * @constructor
         * @param {function(Object):string=} toStrFunction optional function used
         * to convert elements to strings. If the elements aren't strings or if toString()
         * is not appropriate, a custom function which receives an object and returns a
         * unique string must be provided.
         */
        constructor(toStrFunction?: (item: T) => string);
        /**
        * Adds nCopies of the specified object to this bag.
        * @param {Object} element element to add.
        * @param {number=} nCopies the number of copies to add, if this argument is
        * undefined 1 copy is added.
        * @return {boolean} true unless element is undefined.
        */
        add(element: T, nCopies?: number): boolean;
        /**
        * Counts the number of copies of the specified object in this bag.
        * @param {Object} element the object to search for..
        * @return {number} the number of copies of the object, 0 if not found
        */
        count(element: T): number;
        /**
         * Returns true if this bag contains the specified element.
         * @param {Object} element element to search for.
         * @return {boolean} true if this bag contains the specified element,
         * false otherwise.
         */
        contains(element: T): boolean;
        /**
        * Removes nCopies of the specified object to this bag.
        * If the number of copies to remove is greater than the actual number
        * of copies in the Bag, all copies are removed.
        * @param {Object} element element to remove.
        * @param {number=} nCopies the number of copies to remove, if this argument is
        * undefined 1 copy is removed.
        * @return {boolean} true if at least 1 element was removed.
        */
        remove(element: T, nCopies?: number): boolean;
        /**
         * Returns an array containing all of the elements in this big in arbitrary order,
         * including multiple copies.
         * @return {Array} an array containing all of the elements in this bag.
         */
        toArray(): T[];
        /**
         * Returns a set of unique elements in this bag.
         * @return {collections.Set<T>} a set of unique elements in this bag.
         */
        toSet(): Set<T>;
        /**
         * Executes the provided function once for each element
         * present in this bag, including multiple copies.
         * @param {function(Object):*} callback function to execute, it is
         * invoked with one argument: the element. To break the iteration you can
         * optionally return false.
         */
        forEach(callback: ILoopFunction<T>): void;
        /**
         * Returns the number of elements in this bag.
         * @return {number} the number of elements in this bag.
         */
        size(): number;
        /**
         * Returns true if this bag contains no elements.
         * @return {boolean} true if this bag contains no elements.
         */
        isEmpty(): boolean;
        /**
         * Removes all of the elements from this bag.
         */
        clear(): void;
    }
    class BSTree<T> {
        private root;
        private compare;
        private nElements;
        /**
         * Creates an empty binary search tree.
         * @class <p>A binary search tree is a binary tree in which each
         * internal node stores an element such that the elements stored in the
         * left subtree are less than it and the elements
         * stored in the right subtree are greater.</p>
         * <p>Formally, a binary search tree is a node-based binary tree data structure which
         * has the following properties:</p>
         * <ul>
         * <li>The left subtree of a node contains only nodes with elements less
         * than the node's element</li>
         * <li>The right subtree of a node contains only nodes with elements greater
         * than the node's element</li>
         * <li>Both the left and right subtrees must also be binary search trees.</li>
         * </ul>
         * <p>If the inserted elements are custom objects a compare function must
         * be provided at construction time, otherwise the <=, === and >= operators are
         * used to compare elements. Example:</p>
         * <pre>
         * function compare(a, b) {
         *  if (a is less than b by some ordering criterion) {
         *     return -1;
         *  } if (a is greater than b by the ordering criterion) {
         *     return 1;
         *  }
         *  // a must be equal to b
         *  return 0;
         * }
         * </pre>
         * @constructor
         * @param {function(Object,Object):number=} compareFunction optional
         * function used to compare two elements. Must return a negative integer,
         * zero, or a positive integer as the first argument is less than, equal to,
         * or greater than the second.
         */
        constructor(compareFunction?: ICompareFunction<T>);
        /**
         * Adds the specified element to this tree if it is not already present.
         * @param {Object} element the element to insert.
         * @return {boolean} true if this tree did not already contain the specified element.
         */
        add(element: T): boolean;
        /**
         * Removes all of the elements from this tree.
         */
        clear(): void;
        /**
         * Returns true if this tree contains no elements.
         * @return {boolean} true if this tree contains no elements.
         */
        isEmpty(): boolean;
        /**
         * Returns the number of elements in this tree.
         * @return {number} the number of elements in this tree.
         */
        size(): number;
        /**
         * Returns true if this tree contains the specified element.
         * @param {Object} element element to search for.
         * @return {boolean} true if this tree contains the specified element,
         * false otherwise.
         */
        contains(element: T): boolean;
        /**
         * Removes the specified element from this tree if it is present.
         * @return {boolean} true if this tree contained the specified element.
         */
        remove(element: T): boolean;
        /**
         * Executes the provided function once for each element present in this tree in
         * in-order.
         * @param {function(Object):*} callback function to execute, it is invoked with one
         * argument: the element value, to break the iteration you can optionally return false.
         */
        inorderTraversal(callback: ILoopFunction<T>): void;
        /**
         * Executes the provided function once for each element present in this tree in pre-order.
         * @param {function(Object):*} callback function to execute, it is invoked with one
         * argument: the element value, to break the iteration you can optionally return false.
         */
        preorderTraversal(callback: ILoopFunction<T>): void;
        /**
         * Executes the provided function once for each element present in this tree in post-order.
         * @param {function(Object):*} callback function to execute, it is invoked with one
         * argument: the element value, to break the iteration you can optionally return false.
         */
        postorderTraversal(callback: ILoopFunction<T>): void;
        /**
         * Executes the provided function once for each element present in this tree in
         * level-order.
         * @param {function(Object):*} callback function to execute, it is invoked with one
         * argument: the element value, to break the iteration you can optionally return false.
         */
        levelTraversal(callback: ILoopFunction<T>): void;
        /**
         * Returns the minimum element of this tree.
         * @return {*} the minimum element of this tree or undefined if this tree is
         * is empty.
         */
        minimum(): T;
        /**
         * Returns the maximum element of this tree.
         * @return {*} the maximum element of this tree or undefined if this tree is
         * is empty.
         */
        maximum(): T;
        /**
         * Executes the provided function once for each element present in this tree in inorder.
         * Equivalent to inorderTraversal.
         * @param {function(Object):*} callback function to execute, it is
         * invoked with one argument: the element value, to break the iteration you can
         * optionally return false.
         */
        forEach(callback: ILoopFunction<T>): void;
        /**
         * Returns an array containing all of the elements in this tree in in-order.
         * @return {Array} an array containing all of the elements in this tree in in-order.
         */
        toArray(): T[];
        /**
         * Returns the height of this tree.
         * @return {number} the height of this tree or -1 if is empty.
         */
        height(): number;
        /**
        * @private
        */
        private searchNode(node, element);
        /**
        * @private
        */
        private transplant(n1, n2);
        /**
        * @private
        */
        private removeNode(node);
        /**
        * @private
        */
        private inorderTraversalAux(node, callback, signal);
        /**
        * @private
        */
        private levelTraversalAux(node, callback);
        /**
        * @private
        */
        private preorderTraversalAux(node, callback, signal);
        /**
        * @private
        */
        private postorderTraversalAux(node, callback, signal);
        /**
        * @private
        */
        private minimumAux(node);
        /**
        * @private
        */
        private maximumAux(node);
        /**
          * @private
          */
        private heightAux(node);
        private insertNode(node);
        /**
        * @private
        */
        private createNode(element);
    }
}
interface String {
    EndsWith(suffix: string, isgnoreCase?: boolean): boolean;
    StartsWith(prefix: string, isgnoreCase?: boolean): boolean;
}
interface StringConstructor {
    IsNullOrEmpty(value: string): boolean;
    Compare(a: string, b: string, isgnoreCase?: boolean): number;
}
interface Array<T> {
    Contains(item: T): boolean;
    AddRange(items: T[]): void;
    OrderBy(func: (item: T) => number | string): Array<T>;
}
interface BooleanConstructor {
    Parse(value: string): boolean;
}
declare namespace U1 {
    interface IUValue {
        ConvertFromStr(value: string): any;
        ConvertToStr(): string;
        CopyFrom(other: IUValue): any;
        Equals(other: IUValue): boolean;
        Clone(): IUValue;
    }
    class UValueUtil {
        static ConvertArrFromString<T extends IUValue>(ctor: {
            new (): T;
        }, str: string): T[];
        static ConvertArrToString<T extends IUValue>(val: T[]): string;
        static ConvertNumberArrFromString(str: string): number[];
        static ConvertNumberArrToString(...val: number[]): string;
        static ConvertStrArrFromString(str: string): string[];
        static ConvertStrArrToString(...val: string[]): string;
        static Fill_A_With_B<T>(a: T[], b: T[]): void;
    }
    class LogService {
        static WriteExceptionFunc: (err: any) => any;
        static WriteLogsFunc: (logs: string[]) => any;
        static WriteException(err: any): void;
        static WriteLogs(...logs: string[]): void;
    }
    class Event1<S> {
        private listeners;
        Add(thisArg: any, listener: (arg1: S) => any): void;
        Remove(thisArg: any, listener: (arg1: S) => any): void;
        Invoke(arg1: S): void;
        Clear(): void;
    }
    class Event2<S, T> {
        private listeners;
        Add(thisArg: any, listener: (arg1: S, srg2: T) => any): void;
        Remove(thisArg: any, listener: (arg1: S, srg2: T) => any): void;
        Invoke(arg1: S, arg2: T): void;
        Clear(): void;
    }
    class Event3<S, T, U> {
        private listeners;
        Add(thisArg: any, listener: (arg1: S, arg2: T, arg3: U) => any): void;
        Remove(thisArg: any, listener: (arg1: S, arg2: T, arg3: U) => any): void;
        Invoke(arg1: S, arg2: T, arg3: U): void;
        Clear(): void;
    }
    class PropertyChangedEvent extends Event2<Object, string> {
    }
    interface INotifyPropertyChanged {
        PropertyChanged: PropertyChangedEvent;
    }
    interface IDisposable {
        Dispose(): any;
    }
    interface IPropertyContainer extends INotifyPropertyChanged {
        SetProp(prop: string, value: string): any;
        GetProp(prop: string): string;
    }
    interface IUCommandData {
        Label?: string;
        ID?: string;
        ToolTip?: string;
        CanExecuteFunc?: () => boolean;
        ExecuteFunc?: (arg: any) => void;
    }
    class UCommand implements IDisposable {
        private _canExecuteFunc;
        private _executeFunc;
        private _toolTip;
        private _label;
        private _id;
        private static _key;
        private _key;
        constructor(data?: IUCommandData);
        CanExecuteFunc: () => boolean;
        ExecuteFunc: (arg: any) => void;
        Key: string;
        ID: string;
        ToolTip: string;
        Label: string;
        CanExecute(parameter: any): boolean;
        CanExecuteChanged: Event1<UCommand>;
        Execute(arg: any): void;
        InvokeCanExecuteChanged(): void;
        PropertyChanged: PropertyChangedEvent;
        InvokePropertyChanged(prop: string): void;
        Dispose(): void;
    }
    class StringUtil {
        static IsWhiteSpace(char: string): boolean;
        static IsDigit(char: string): boolean;
        static IsLetterOrDigit(char: string): boolean;
        static IsLetter(char: string): boolean;
    }
    class StringBuilder {
        private buffer;
        private length;
        Append(value: string): void;
        toString(): string;
        Length: number;
    }
    class Utf8Util {
        /**
        * Encodes multi-byte Unicode string into utf-8 multiple single-byte characters
        * (BMP / basic multilingual plane only).
        *
        * Chars in range U+0080 - U+07FF are encoded in 2 chars, U+0800 - U+FFFF in 3 chars.
        *
        * Can be achieved in JavaScript by unescape(encodeURIComponent(str)),
        * but this approach may be useful in other languages.
        *
        * @param {string} strUni Unicode string to be encoded as UTF-8.
        * @returns {string} Encoded string.
        */
        static Utf8Encode(strUni: string): string;
        /**
         * Decodes utf-8 encoded string back into multi-byte Unicode characters.
         *
         * Can be achieved JavaScript by decodeURIComponent(escape(str)),
         * but this approach may be useful in other languages.
         *
         * @param {string} strUtf UTF-8 string to be decoded back to Unicode.
         * @returns {string} Decoded string.
         */
        static Utf8Decode(strUtf: string): string;
    }
    function utf8_to_b64(str: any): string;
    function b64_to_utf8(str: any): string;
    function decimalToHex(d: number, padding?: number): string;
    function OpenFileDialog(calback: (files: FileList) => void, accept?: string): void;
    function SaveTextFile(output: string, type?: string, file?: string): void;
    function SaveImageFile(canvas: HTMLCanvasElement, file?: string): void;
    enum MessageBoxButton {
        OK = 0,
        OKCancel = 1,
    }
    enum MessageBoxResult {
        None = 0,
        OK = 1,
        Cancel = 2,
        Yes = 6,
        No = 7,
    }
    class MessageBox {
        static Show(message: string, title?: string, button?: MessageBoxButton): MessageBoxResult;
    }
    class UDispatcher {
        static BeginInvoke(func: (...arg: any[]) => any, ...arg: any[]): void;
        static BeginInvokeDelay(func: (...arg: any[]) => any, delay: number, ...arg: any[]): void;
    }
    class AddressParams {
        static getParameter(name: any): string;
        static getParameters(): {
            [index: string]: string;
        };
    }
    function isIE9(): boolean;
}
declare namespace U1 {
    var PRECISION: number;
    var Epsilon: number;
    function WithinEpsilon(a: number, b: number): boolean;
    function Clamp(value: number, min: number, max: number): number;
    function EpsilonEqualsPointPoint(point0: Vector2, point1: Vector2, epsilon?: number): boolean;
    function RandomVector3(): Vector3[];
    class Cache<T> {
        private _items;
        private _link;
        private _head_fill;
        private _head_empty;
        private _creater;
        constructor(creter: {
            new (): T;
        }, size?: number);
        New(): T;
        Release(v: T): Cache<T>;
    }
    class Vector2 implements U1.IUValue {
        X: number;
        Y: number;
        Tag: any;
        constructor(x?: number, y?: number);
        ConvertFromStr(value: string): void;
        ConvertToStr(): string;
        CopyFrom(other: Vector2): void;
        toString(): string;
        Clone(): Vector2;
        Left: Vector2;
        Right: Vector2;
        LeftRef(ref: Vector2): Vector2;
        RightRef(ref: Vector2): Vector2;
        static MaxValue: Vector2;
        static MinValue: Vector2;
        SetMaxValue(): Vector2;
        SetMinValue(): Vector2;
        Set(x: number, y: number): Vector2;
        Equals(other: Vector2): boolean;
        EpsilonEquals(point1: Vector2, epsilon?: number): boolean;
        static EpsilonEquals(point0: Vector2, point1: Vector2, epsilon?: number): boolean;
        Length(): number;
        LengthSquareduared(): number;
        static Distance(value1: Vector2, value2: Vector2): number;
        static DistanceSquared(value1: Vector2, value2: Vector2): number;
        static Dot(a: Vector2, b: Vector2): number;
        Normalize(): Vector2;
        static Normalize(value: Vector2, result?: Vector2): Vector2;
        SetNormalize(value: Vector2): Vector2;
        static Reflect(vector: Vector2, normal: Vector2, result?: Vector2): Vector2;
        SetReflect(vector: Vector2, normal: Vector2): Vector2;
        static Min(value1: Vector2, value2: Vector2, result?: Vector2): Vector2;
        SetMin(value1: Vector2, value2: Vector2): Vector2;
        static Max(value1: Vector2, value2: Vector2, result?: Vector2): Vector2;
        SetMax(value1: Vector2, value2: Vector2): Vector2;
        static Clamp(value1: Vector2, min: Vector2, max: Vector2, result?: Vector2): Vector2;
        SetClamp(value1: Vector2, min: Vector2, max: Vector2): Vector2;
        static Lerp(value1: Vector2, value2: Vector2, amount: number, result?: Vector2): Vector2;
        SetLerpRef(value1: Vector2, value2: Vector2, amount: number): Vector2;
        static Barycentric(value1: Vector2, value2: Vector2, value3: Vector2, amount1: number, amount2: number, result?: Vector2): Vector2;
        SetBarycentric(value1: Vector2, value2: Vector2, value3: Vector2, amount1: number, amount2: number): Vector2;
        static SmoothStep(value1: Vector2, value2: Vector2, amount: number, result?: Vector2): Vector2;
        SetSmoothStep(value1: Vector2, value2: Vector2, amount: number): Vector2;
        static CatmullRom(value1: Vector2, value2: Vector2, value3: Vector2, value4: Vector2, amount: number, result: Vector2): Vector2;
        SetCatmullRom(value1: Vector2, value2: Vector2, value3: Vector2, value4: Vector2, amount: number): Vector2;
        static Hermite(value1: Vector2, tangent1: Vector2, value2: Vector2, tangent2: Vector2, amount: number, result?: Vector2): Vector2;
        SetHermite(value1: Vector2, tangent1: Vector2, value2: Vector2, tangent2: Vector2, amount: number): Vector2;
        Transform(matrix: Matrix4): void;
        static Transform(position: Vector2, matrix: Matrix4, result?: Vector2): Vector2;
        SetTransform(position: Vector2, matrix: Matrix4): Vector2;
        static TransformNormal(normal: Vector2, matrix: Matrix4, result?: Vector2): Vector2;
        SetTransformNormal(normal: Vector2, matrix: Matrix4): Vector2;
        static TransformQuaternion(value: Vector2, rotation: Quaternion, result?: Vector2): Vector2;
        SetTransformQuaternion(value: Vector2, rotation: Quaternion): Vector2;
        Negate(): Vector2;
        static Negate(value: Vector2, result?: Vector2): Vector2;
        SetNegate(value: Vector2): Vector2;
        Add(value1: Vector2): Vector2;
        static Add(value1: Vector2, value2: Vector2, result?: Vector2): Vector2;
        SetAdd(value1: Vector2, value2: Vector2): Vector2;
        ScaleAdd(scale: number, dir: Vector2): Vector2;
        static ScaleAdd(pos: Vector2, scale: number, dir: Vector2, result?: Vector2): Vector2;
        SetScaleAdd(pos: Vector2, scale: number, dir: Vector2): Vector2;
        Subtract(value1: Vector2): Vector2;
        static Subtract(value1: Vector2, value2: Vector2, result?: Vector2): Vector2;
        SetSubtract(value1: Vector2, value2: Vector2): Vector2;
        Multiply(value1: Vector2): Vector2;
        static Multiply(value1: Vector2, value2: Vector2, result?: Vector2): Vector2;
        SetMultiply(value1: Vector2, value2: Vector2): Vector2;
        Scale(scaleFactor: number): Vector2;
        static Scale(value1: Vector2, scaleFactor: number, result?: Vector2): Vector2;
        SetScale(value1: Vector2, scaleFactor: number): Vector2;
        Divide(value1: Vector2): Vector2;
        static Divide(value1: Vector2, value2: Vector2, result?: Vector2): Vector2;
        SetDivide(value1: Vector2, value2: Vector2): Vector2;
        Minimize(right: Vector2): Vector2;
        static Minimize(left: Vector2, right: Vector2, result?: Vector2): Vector2;
        SetMinimize(left: Vector2, right: Vector2): Vector2;
        Maximize(right: Vector2): Vector2;
        static Maximize(left: Vector2, right: Vector2, result?: Vector2): Vector2;
        SetMaximize(left: Vector2, right: Vector2): Vector2;
        ToArray(array: number[], index?: number): Vector2;
        AsArray(): number[];
        static Create(x: number, y: number): Vector2;
        static Zero: Vector2;
        static One: Vector2;
        static UnitX: Vector2;
        static UnitY: Vector2;
        SetZero(): Vector2;
        SetOne(): Vector2;
        SetUnitX(): Vector2;
        SetUnitY(): Vector2;
        private static _cache;
        static New(): Vector2;
        static Release(v: Vector2): void;
        Release(): void;
    }
    class Vector3 implements U1.IUValue {
        X: number;
        Y: number;
        Z: number;
        static Dot(a: Vector3, b: Vector3): number;
        ConvertFromStr(value: string): void;
        ConvertToStr(): string;
        toString(): string;
        constructor(x?: number, y?: number, z?: number);
        static Create(x: number, y: number, z: number): Vector3;
        Set(x: number, y: number, z: number): this;
        Clone(): Vector3;
        CopyFrom(source: Vector3): Vector3;
        IsZero: boolean;
        static Zero: Vector3;
        SetZero(): Vector3;
        static One: Vector3;
        SetOne(): Vector3;
        static UnitX: Vector3;
        SetUnitX(): Vector3;
        static UnitY: Vector3;
        SetUnitY(): Vector3;
        static UnitZ: Vector3;
        SetUnitZ(): Vector3;
        static Up: Vector3;
        SetUp(): Vector3;
        static Down: Vector3;
        SetDown(): Vector3;
        static Right: Vector3;
        SetRight(): Vector3;
        static Left: Vector3;
        SetLeft(): Vector3;
        static Forward: Vector3;
        SetForward(): Vector3;
        static Backward: Vector3;
        SetBackward(): Vector3;
        static MaxValue: Vector3;
        SetMaxValue(): Vector3;
        static MinValue: Vector3;
        SetMinValue(): Vector3;
        Equals(other: Vector3): boolean;
        static Equals(value1: Vector3, value2: Vector3): boolean;
        EpsilonEquals(other: Vector3, epsilon: number): boolean;
        static EpsilonEquals(point0: Vector3, point1: Vector3, epsilon?: number): boolean;
        static Length(offset: Vector3): number;
        Length(): number;
        LengthSquareduared(): number;
        static Distance(value1: Vector3, value2: Vector3): number;
        Distance(value2: Vector3): number;
        static DistanceSquared(value1: Vector3, value2: Vector3): number;
        DistanceSquared(value2: Vector3): number;
        Normalize(): Vector3;
        static Normalize(value: Vector3, result?: Vector3): Vector3;
        SetNormalize(value: Vector3): Vector3;
        static Cross(vector1: Vector3, vector2: Vector3, result?: Vector3): Vector3;
        SetCross(vector1: Vector3, vector2: Vector3): Vector3;
        Cross(vector2: Vector3): Vector3;
        static Reflect(vector: Vector3, normal: Vector3, result?: Vector3): Vector3;
        SetReflect(vector: Vector3, normal: Vector3): Vector3;
        Reflect(normal: Vector3): Vector3;
        static Min(value1: Vector3, value2: Vector3, result?: Vector3): Vector3;
        SetMin(value1: Vector3, value2: Vector3): Vector3;
        static Max(value1: Vector3, value2: Vector3, result?: Vector3): Vector3;
        SetMax(value1: Vector3, value2: Vector3): Vector3;
        static Clamp(value1: Vector3, min: Vector3, max: Vector3, result?: Vector3): Vector3;
        SetClamp(value1: Vector3, min: Vector3, max: Vector3): Vector3;
        /**
        * Performs a linear interpolation.
        * 선형보간
        */
        static Lerp(value1: Vector3, value2: Vector3, amount: number, result?: Vector3): Vector3;
        SetLerp(value1: Vector3, value2: Vector3, amount: number): Vector3;
        Lerp(value2: Vector3, amount: number): Vector3;
        /**
        * 무게중심
        */
        static Barycentric(value1: Vector3, value2: Vector3, value3: Vector3, amount1: number, amount2: number, result?: Vector3): Vector3;
        SetBarycentric(value1: Vector3, value2: Vector3, value3: Vector3, amount1: number, amount2: number): Vector3;
        Barycentric(value2: Vector3, value3: Vector3, amount1: number, amount2: number): Vector3;
        static SmoothStep(value1: Vector3, value2: Vector3, amount: number, result?: Vector3): Vector3;
        SetSmoothStep(value1: Vector3, value2: Vector3, amount: number): Vector3;
        SmoothStep(value2: Vector3, amount: number): Vector3;
        static CatmullRom(value1: Vector3, value2: Vector3, value3: Vector3, value4: Vector3, amount: number, result?: Vector3): Vector3;
        SetCatmullRom(value1: Vector3, value2: Vector3, value3: Vector3, value4: Vector3, amount: number): Vector3;
        CatmullRom(value2: Vector3, value3: Vector3, value4: Vector3, amount: number): Vector3;
        static Hermite(value1: Vector3, tangent1: Vector3, value2: Vector3, tangent2: Vector3, amount: number, result?: Vector3): Vector3;
        SetHermite(value1: Vector3, tangent1: Vector3, value2: Vector3, tangent2: Vector3, amount: number): Vector3;
        static Transform(position: Vector3, matrix: Matrix4, result?: Vector3): Vector3;
        SetTransform(position: Vector3, matrix: Matrix4): Vector3;
        Transform(matrix: Matrix4): Vector3;
        static TransformNormal(normal: Vector3, matrix: Matrix4, result?: Vector3): Vector3;
        SetTransformNormal(normal: Vector3, matrix: Matrix4): Vector3;
        TransformNormal(matrix: Matrix4): Vector3;
        static Negate(value: Vector3, result?: Vector3): Vector3;
        SetNegate(value: Vector3): Vector3;
        Negate(): Vector3;
        static Add(value1: Vector3, value2: Vector3, result?: Vector3): Vector3;
        SetAdd(value1: Vector3, value2: Vector3): Vector3;
        Add(value2: Vector3): Vector3;
        static Subtract(value1: Vector3, value2: Vector3, result?: Vector3): Vector3;
        SetSubtract(value1: Vector3, value2: Vector3): Vector3;
        Subtract(value2: Vector3): Vector3;
        static Multiply(value1: Vector3, value2: Vector3, result?: Vector3): Vector3;
        SetMultiply(value1: Vector3, value2: Vector3): Vector3;
        Multiply(value2: Vector3): Vector3;
        static Scale(value1: Vector3, scaleFactor: number, result?: Vector3): Vector3;
        SetScale(value1: Vector3, scaleFactor: number): Vector3;
        Scale(scaleFactor: number): Vector3;
        static ScaleAdd(pos: Vector3, scale: number, dir: Vector3, result?: Vector3): Vector3;
        SetScaleAdd(pos: Vector3, scale: number, dir: Vector3): Vector3;
        ScaleAdd(scale: number, dir: Vector3): Vector3;
        static Divide(value1: Vector3, value2: Vector3, result?: Vector3): Vector3;
        SetDivide(value1: Vector3, value2: Vector3): Vector3;
        Divide(value2: Vector3): Vector3;
        static Project(source: Vector3, projection: Matrix4, view: Matrix4, world: Matrix4, screenSize: Vector2, mindepth: number, maxdepth: number, result?: Vector3): Vector3;
        SetProject(source: Vector3, projection: Matrix4, view: Matrix4, world: Matrix4, screenSize: Vector2, mindepth: number, maxdepth: number): Vector3;
        Minimize(other: Vector3): Vector3;
        static Minimize(left: Vector3, right: Vector3, result?: Vector3): Vector3;
        SetMinimize(left: Vector3, right: Vector3): Vector3;
        Maximize(other: Vector3): Vector3;
        static Maximize(left: Vector3, right: Vector3, result: Vector3): Vector3;
        SetMaximize(left: Vector3, right: Vector3): Vector3;
        XY(result?: Vector2): Vector2;
        YZ(result?: Vector2): Vector2;
        private static _cache;
        static New(): Vector3;
        static NewArray(num: number): Vector3[];
        static Release(v: Vector3 | Vector3[]): void;
        Release(): void;
    }
    class Vector4 implements U1.IUValue {
        X: number;
        Y: number;
        Z: number;
        W: number;
        constructor(x?: number, y?: number, z?: number, w?: number);
        ConvertFromStr(value: string): void;
        ConvertToStr(): string;
        toString(): string;
        Set(x?: number, y?: number, z?: number, w?: number): Vector4;
        static Zero: Vector4;
        static ZeroRef(ref: Vector4): Vector4;
        SetZero(): Vector4;
        static One: Vector4;
        SetOne(): Vector4;
        static UnitX: Vector4;
        SetUnitX(): Vector4;
        static UnitY: Vector4;
        SetUnitY(ref: Vector4): Vector4;
        static UnitZ: Vector4;
        SetUnitZ(ref: Vector4): Vector4;
        static UnitW: Vector4;
        SetUnitW(ref: Vector4): Vector4;
        Clone(): Vector4;
        CopyFrom(source: Vector4): Vector4;
        static FromArray(array: number[], offset?: number): Vector4;
        Equals(other: Vector4): boolean;
        EpsilonEquals(other: Vector4, epsilon: number): boolean;
        static EpsilonEquals(point0: Vector4, point1: Vector4, epsilon?: number): boolean;
        Length(): number;
        LengthSquareduared(): number;
        static Distance(value1: Vector4, value2: Vector4): number;
        static DistanceSquared(value1: Vector4, value2: Vector4): number;
        static Dot(vector1: Vector4, vector2: Vector4): number;
        Normalize(): void;
        static Normalize(vector: Vector4, result?: Vector4): Vector4;
        SetNormalize(vector: Vector4): Vector4;
        static Min(value1: Vector4, value2: Vector4, result?: Vector4): Vector4;
        SetMin(value1: Vector4, value2: Vector4): Vector4;
        static Max(value1: Vector4, value2: Vector4, result?: Vector4): Vector4;
        SetMax(value1: Vector4, value2: Vector4): Vector4;
        static Clamp(value1: Vector4, min: Vector4, max: Vector4, result?: Vector4): Vector4;
        SetClamp(value1: Vector4, min: Vector4, max: Vector4): Vector4;
        static Lerp(value1: Vector4, value2: Vector4, amount: number, result?: Vector4): Vector4;
        SetLerp(value1: Vector4, value2: Vector4, amount: number): Vector4;
        static Barycentric(value1: Vector4, value2: Vector4, value3: Vector4, amount1: number, amount2: number, result?: Vector4): Vector4;
        SetBarycentric(value1: Vector4, value2: Vector4, value3: Vector4, amount1: number, amount2: number): Vector4;
        static SmoothStepRef(value1: Vector4, value2: Vector4, amount: number, result?: Vector4): Vector4;
        SetSmoothStep(value1: Vector4, value2: Vector4, amount: number): Vector4;
        static CatmullRomRef(value1: Vector4, value2: Vector4, value3: Vector4, value4: Vector4, amount: number, result?: Vector4): Vector4;
        SetCatmullRom(value1: Vector4, value2: Vector4, value3: Vector4, value4: Vector4, amount: number): Vector4;
        static HermiteRef(value1: Vector4, tangent1: Vector4, value2: Vector4, tangent2: Vector4, amount: number, result?: Vector4): Vector4;
        SetHermite(value1: Vector4, tangent1: Vector4, value2: Vector4, tangent2: Vector4, amount: number): Vector4;
        static TransformVector2(position: Vector2, matrix: Matrix4, result?: Vector4): Vector4;
        SetTransformVector2(position: Vector2, matrix: Matrix4): Vector4;
        static TransformVector3(position: Vector3, matrix: Matrix4, result?: Vector4): Vector4;
        SetTransformVector3(position: Vector3, matrix: Matrix4): Vector4;
        static Transform(vector: Vector4, matrix: Matrix4, result?: Vector4): Vector4;
        SetTransform(vector: Vector4, matrix: Matrix4): Vector4;
        static TransformVector2Quaternion(value: Vector2, rotation: Quaternion, result?: Vector4): Vector4;
        SetTransformVector2Quaternion(value: Vector2, rotation: Quaternion): Vector4;
        static TransformVector3Quaternion(value: Vector3, rotation: Quaternion, result?: Vector4): Vector4;
        SetTransformVector3Quaternion(value: Vector3, rotation: Quaternion): Vector4;
        static TransformVector4Quaternion(value: Vector4, rotation: Quaternion, result?: Vector4): Vector4;
        SetTransformVector4Quaternion(value: Vector4, rotation: Quaternion): Vector4;
        static Negate(value: Vector4, result: Vector4): Vector4;
        SetNegate(value: Vector4): Vector4;
        Negate(): Vector4;
        static Add(value1: Vector4, value2: Vector4, result?: Vector4): Vector4;
        SetAdd(value1: Vector4, value2: Vector4): Vector4;
        Add(value1: Vector4): Vector4;
        static Subtract(value1: Vector4, value2: Vector4, result?: Vector4): Vector4;
        SetSubtract(value1: Vector4, value2: Vector4): Vector4;
        Subtract(value2: Vector4): Vector4;
        static Multiply(value1: Vector4, value2: Vector4, result?: Vector4): Vector4;
        SetMultiply(value1: Vector4, value2: Vector4): Vector4;
        Multiply(value2: Vector4): Vector4;
        static Scale(value1: Vector4, scaleFactor: number, result?: Vector4): Vector4;
        SetScale(value1: Vector4, scaleFactor: number): Vector4;
        Scale(scaleFactor: number): Vector4;
        static Divide(value1: Vector4, value2: Vector4, result?: Vector4): Vector4;
        SetDivide(value1: Vector4, value2: Vector4): Vector4;
        Divide(value2: Vector4): Vector4;
        private static _cache;
        static New(): Vector4;
        static Release(v: Vector4): void;
        Release(): void;
    }
    class Matrix4 implements U1.IUValue {
        M11: number;
        M12: number;
        M13: number;
        M14: number;
        M21: number;
        M22: number;
        M23: number;
        M24: number;
        M31: number;
        M32: number;
        M33: number;
        M34: number;
        M41: number;
        M42: number;
        M43: number;
        M44: number;
        private static tv0;
        private static tv1;
        private static tv2;
        private static tv3;
        ConvertFromStr(value: string): void;
        ConvertToStr(): string;
        Clone(): Matrix4;
        Equals(other: Matrix4): boolean;
        CopyFrom(other: Matrix4): Matrix4;
        constructor(m11?: number, m12?: number, m13?: number, m14?: number, m21?: number, m22?: number, m23?: number, m24?: number, m31?: number, m32?: number, m33?: number, m34?: number, m41?: number, m42?: number, m43?: number, m44?: number);
        Set(m11?: number, m12?: number, m13?: number, m14?: number, m21?: number, m22?: number, m23?: number, m24?: number, m31?: number, m32?: number, m33?: number, m34?: number, m41?: number, m42?: number, m43?: number, m44?: number): this;
        static Identity: Matrix4;
        SetIdentity(): Matrix4;
        Up: Vector3;
        GetUp(result?: Vector3): Vector3;
        Down: Vector3;
        GetDown(result?: Vector3): Vector3;
        Right: Vector3;
        GetRight(result?: Vector3): Vector3;
        Left: Vector3;
        GetLeft(result?: Vector3): Vector3;
        Forward: Vector3;
        GetForward(result?: Vector3): Vector3;
        Backward: Vector3;
        GetBackward(result?: Vector3): Vector3;
        Translation: Vector3;
        GetTranslation(result?: Vector3): Vector3;
        static CreateFromAxes(xAxis: Vector3, yAxis: Vector3, zAxis: Vector3, result?: Matrix4): Matrix4;
        static CreateBillboard(objectPosition: Vector3, cameraPosition: Vector3, cameraUpVector: Vector3, cameraForwardVector: Vector3, result?: Matrix4): Matrix4;
        SetCreateBillboard(objectPosition: Vector3, cameraPosition: Vector3, cameraUpVector: Vector3, cameraForwardVector: Vector3): Matrix4;
        static CreateConstrainedBillboard(objectPosition: Vector3, cameraPosition: Vector3, rotateAxis: Vector3, cameraForwardVector: Vector3, objectForwardVector: Vector3, result?: Matrix4): Matrix4;
        SetCreateConstrainedBillboard(objectPosition: Vector3, cameraPosition: Vector3, rotateAxis: Vector3, cameraForwardVector: Vector3, objectForwardVector: Vector3): Matrix4;
        static CreateTranslation(position: Vector3, result?: Matrix4): Matrix4;
        SetCreateTranslation(position: Vector3): Matrix4;
        static CreateScaleByFloats(xScale: number, yScale: number, zScale: number, result?: Matrix4): Matrix4;
        SetCreateScaleByFloats(xScale: number, yScale: number, zScale: number): Matrix4;
        static CreateScale(scales: Vector3, reslut?: Matrix4): Matrix4;
        SetCreateScale(scales: Vector3): Matrix4;
        static CreateRotationX(radians: number, result?: Matrix4): Matrix4;
        SetCreateRotationX(radians: number): Matrix4;
        static CreateRotationY(radians: number, result?: Matrix4): Matrix4;
        SetCreateRotationY(radians: number): Matrix4;
        static CreateRotationZ(radians: number, result?: Matrix4): Matrix4;
        SetCreateRotationZ(radians: number): Matrix4;
        static CreateFromAxisAngle(axis: Vector3, angle: number, result?: Matrix4): Matrix4;
        SetCreateFromAxisAngle(axis: Vector3, angle: number): Matrix4;
        static CreatePerspectiveFieldOfView(fieldOfView: number, aspectRatio: number, nearPlaneDistance: number, farPlaneDistance: number, result?: Matrix4): Matrix4;
        SetCreatePerspectiveFieldOfView(fieldOfView: number, aspectRatio: number, nearPlaneDistance: number, farPlaneDistance: number): Matrix4;
        static CreatePerspective(width: number, height: number, nearPlaneDistance: number, farPlaneDistance: number): Matrix4;
        SetCreatePerspective(width: number, height: number, nearPlaneDistance: number, farPlaneDistance: number): Matrix4;
        static CreatePerspectiveOffCenter(left: number, right: number, bottom: number, top: number, nearPlaneDistance: number, farPlaneDistance: number, result?: Matrix4): Matrix4;
        SetCreatePerspectiveOffCenter(left: number, right: number, bottom: number, top: number, nearPlaneDistance: number, farPlaneDistance: number): Matrix4;
        static CreateOrthographic(width: number, height: number, zNearPlane: number, zFarPlane: number, result?: Matrix4): Matrix4;
        SetCreateOrthographic(width: number, height: number, zNearPlane: number, zFarPlane: number): Matrix4;
        static CreateOrthographicOffCenter(left: number, right: number, bottom: number, top: number, zNearPlane: number, zFarPlane: number, result?: Matrix4): Matrix4;
        SetCreateOrthographicOffCenter(left: number, right: number, bottom: number, top: number, zNearPlane: number, zFarPlane: number): Matrix4;
        static CreateLookAt(cameraPosition: Vector3, cameraTarget: Vector3, cameraUpVector: Vector3, result?: Matrix4): Matrix4;
        SetCreateLookAt(cameraPosition: Vector3, cameraTarget: Vector3, cameraUpVector: Vector3): Matrix4;
        static CreateWorld(position: Vector3, forward: Vector3, up: Vector3, result?: Matrix4): Matrix4;
        SetCreateWorld(position: Vector3, forward: Vector3, up: Vector3): Matrix4;
        static CreateFromQuaternion(quaternion: Quaternion, result?: Matrix4): Matrix4;
        SetCreateFromQuaternion(quaternion: Quaternion): Matrix4;
        static CreateFromYawPitchRoll(yaw: number, pitch: number, roll: number, result?: Matrix4): Matrix4;
        SetCreateFromYawPitchRoll(yaw: number, pitch: number, roll: number): Matrix4;
        static CreateShadow(lightDirection: Vector3, plane: Plane, result?: Matrix4): Matrix4;
        SetCreateShadow(lightDirection: Vector3, plane: Plane): Matrix4;
        static CreateReflection(value: Plane, result?: Matrix4): Matrix4;
        SetCreateReflection(value: Plane): Matrix4;
        static TransformByQuaternion(value: Matrix4, rotation: Quaternion, result?: Matrix4): Matrix4;
        SetTransformByQuaternion(value: Matrix4, rotation: Quaternion): Matrix4;
        static Transpose(matrix: Matrix4, result?: Matrix4): Matrix4;
        SetTranspose(matrix: Matrix4): Matrix4;
        Determinant(): number;
        static Invert(matrix: Matrix4, result?: Matrix4): Matrix4;
        SetInvert(source: Matrix4): Matrix4;
        Invert(): Matrix4;
        static Lerp(matrix1: Matrix4, matrix2: Matrix4, amount: number, result?: Matrix4): Matrix4;
        SetLerp(matrix1: Matrix4, matrix2: Matrix4, amount: number): Matrix4;
        static Negate(matrix: Matrix4, result?: Matrix4): Matrix4;
        SetNegate(matrix: Matrix4): Matrix4;
        Negate(matrix: Matrix4): Matrix4;
        static Add(matrix1: Matrix4, matrix2: Matrix4, result?: Matrix4): Matrix4;
        SetAdd(matrix1: Matrix4, matrix2: Matrix4): Matrix4;
        Add(matrix2: Matrix4): Matrix4;
        static Subtract(matrix1: Matrix4, matrix2: Matrix4, result?: Matrix4): Matrix4;
        SetSubtract(matrix1: Matrix4, matrix2: Matrix4): Matrix4;
        Subtract(matrix2: Matrix4): Matrix4;
        static Multiply(matrix1: Matrix4, matrix2: Matrix4, result?: Matrix4): Matrix4;
        SetMultiply(matrix1: Matrix4, matrix2: Matrix4): Matrix4;
        Multiply(matrix2: Matrix4): Matrix4;
        static Scale(matrix1: Matrix4, scaleFactor: number, result?: Matrix4): Matrix4;
        SetScale(matrix1: Matrix4, scaleFactor: number): Matrix4;
        Scale(scaleFactor: number): Matrix4;
        static Divide(matrix1: Matrix4, matrix2: Matrix4, result?: Matrix4): Matrix4;
        SetDivide(matrix1: Matrix4, matrix2: Matrix4): Matrix4;
        Divide(matrix2: Matrix4): Matrix4;
        static DivideFloat(matrix1: Matrix4, divider: number, result?: Matrix4): Matrix4;
        SetDivideFloat(matrix1: Matrix4, divider: number): Matrix4;
        M1: Vector4;
        GetM1(result?: Vector4): Vector4;
        M2: Vector4;
        GetM2(result?: Vector4): Vector4;
        M3: Vector4;
        GetM3(result?: Vector4): Vector4;
        M4: Vector4;
        GetM4(result?: Vector4): Vector4;
        private static _cache;
        static New(): Matrix4;
        static Release(v: Matrix4): void;
        Release(): void;
    }
    class Quaternion implements U1.IUValue {
        X: number;
        Y: number;
        Z: number;
        W: number;
        constructor(x?: number, y?: number, z?: number, w?: number);
        ConvertFromStr(value: string): void;
        ConvertToStr(): string;
        Equals(other: Quaternion): boolean;
        CopyFrom(other: Quaternion): void;
        Clone(): Quaternion;
        static Identity: Quaternion;
        LengthSquareduared(): number;
        Length(): number;
        Normalize(): void;
        static Normalize(quaternion: Quaternion, result?: Quaternion): Quaternion;
        SetNormalize(quaternion: Quaternion): Quaternion;
        Conjugate(): void;
        static Conjugate(value: Quaternion, result?: Quaternion): Quaternion;
        SetConjugate(value: Quaternion): Quaternion;
        static Inverse(quaternion: Quaternion, result?: Quaternion): Quaternion;
        SetInverse(quaternion: Quaternion): Quaternion;
        Inverse(): Quaternion;
        static CreateFromAxisAngle(axis: Vector3, angle: number, result?: Quaternion): Quaternion;
        SetCreateFromAxisAngle(axis: Vector3, angle: number): Quaternion;
        static CreateFromYawPitchRoll(yaw: number, pitch: number, roll: number, result?: Quaternion): Quaternion;
        SetCreateFromYawPitchRoll(yaw: number, pitch: number, roll: number): Quaternion;
        static CreateFromRotationMatrix(matrix: Matrix4, result?: Quaternion): Quaternion;
        SetCreateFromRotationMatrix(matrix: Matrix4): Quaternion;
        static Dot(quaternion1: Quaternion, quaternion2: Quaternion): number;
        static Slerp(quaternion1: Quaternion, quaternion2: Quaternion, amount: number, result?: Quaternion): Quaternion;
        SetSlerp(quaternion1: Quaternion, quaternion2: Quaternion, amount: number): Quaternion;
        Slerp(quaternion2: Quaternion, amount: number): Quaternion;
        static Lerp(quaternion1: Quaternion, quaternion2: Quaternion, amount: number, result?: Quaternion): Quaternion;
        SetLerp(quaternion1: Quaternion, quaternion2: Quaternion, amount: number): Quaternion;
        Lerp(quaternion2: Quaternion, amount: number): Quaternion;
        static Concatenate(value1: Quaternion, value2: Quaternion, result?: Quaternion): Quaternion;
        SetConcatenate(value1: Quaternion, value2: Quaternion): Quaternion;
        Concatenate(value2: Quaternion): Quaternion;
        static Negate(quaternion: Quaternion): Quaternion;
        SetNegate(quaternion: Quaternion): Quaternion;
        Negate(): Quaternion;
        static Add(quaternion1: Quaternion, quaternion2: Quaternion, result?: Quaternion): Quaternion;
        SetAdd(quaternion1: Quaternion, quaternion2: Quaternion): Quaternion;
        Add(quaternion2: Quaternion): Quaternion;
        static Subtract(quaternion1: Quaternion, quaternion2: Quaternion, result?: Quaternion): Quaternion;
        SetSubtract(quaternion1: Quaternion, quaternion2: Quaternion): Quaternion;
        Subtract(quaternion2: Quaternion): Quaternion;
        static Multiply(quaternion1: Quaternion, quaternion2: Quaternion, result?: Quaternion): Quaternion;
        SetMultiply(quaternion1: Quaternion, quaternion2: Quaternion): Quaternion;
        Multiply(quaternion2: Quaternion): Quaternion;
        static Scale(quaternion1: Quaternion, scaleFactor: number, result?: Quaternion): Quaternion;
        SetScale(quaternion1: Quaternion, scaleFactor: number): Quaternion;
        Scale(scaleFactor: number): Quaternion;
        static Divide(quaternion1: Quaternion, quaternion2: Quaternion, result?: Quaternion): Quaternion;
        SetDivide(quaternion1: Quaternion, quaternion2: Quaternion): Quaternion;
        Divide(quaternion2: Quaternion): Quaternion;
        ToAxisAngle(): {
            Axis: Vector3;
            Angle: number;
        };
        private static _cache;
        static New(): Quaternion;
        static Release(v: Quaternion): void;
        Release(): void;
    }
    enum PlaneIntersectionTypeEnum {
        Front = 0,
        Back = 1,
        Intersecting = 2,
    }
    enum ContainmentTypeEnum {
        Disjoint = 0,
        Contains = 1,
        Intersects = 2,
    }
    class Plane implements U1.IUValue {
        Normal: Vector3;
        D: number;
        ConvertFromStr(value: string): void;
        ConvertToStr(): string;
        Equals(other: Plane): boolean;
        Set(nx: number, ny: number, nz: number, d: number): Plane;
        Clone(): Plane;
        CopyFrom(source: Plane): Plane;
        constructor(a?: number, b?: number, c?: number, d?: number);
        static Zero(): Plane;
        SetZeroRef(): Plane;
        Normalize(): Plane;
        static Normalize(value: Plane, result?: Plane): Plane;
        SetNormalize(value: Plane): Plane;
        static Transform(plane: Plane, matrix: Matrix4, result?: Plane): Plane;
        SetTransform(plane: Plane, matrix: Matrix4): Plane;
        static TransformQuaternion(plane: Plane, rotation: Quaternion, result?: Plane): Plane;
        SetTransformQuaternion(plane: Plane, rotation: Quaternion): Plane;
        Dot(value: Vector4): number;
        DotCoordinate(value: Vector3): number;
        DotNormal(value: Vector3): number;
        IntersectsBoundingBox(box: BoundingBox): PlaneIntersectionTypeEnum;
        /**
        * 선과 면의 교차
        * @return : 교차되면 선위의 위치, 아니면 null
        */
        IntersectsLine(position: Vector3, direction: Vector3): number;
        Intersects(frustum: BoundingFrustum): PlaneIntersectionTypeEnum;
        IntersectsBoundingSphere(sphere: BoundingSphere): PlaneIntersectionTypeEnum;
        static FromPointNormal(point: Vector3, normal: Vector3, result?: Plane): Plane;
        SetFromPointNormal(point: Vector3, normal: Vector3): Plane;
        static FromTriangle(point1: Vector3, point2: Vector3, point3: Vector3, result?: Plane): Plane;
        SetFromTriangle(point1: Vector3, point2: Vector3, point3: Vector3): Plane;
        private static _cache;
        static New(): Plane;
        static Release(v: Plane): void;
        Release(): void;
    }
    class BoundingBox implements U1.IUValue {
        Min: Vector3;
        Max: Vector3;
        constructor(min?: Vector3, max?: Vector3);
        GetCorners(): Array<Vector3>;
        Equals(other: BoundingBox): boolean;
        Set(...params: Vector3[]): BoundingBox;
        Clone(): BoundingBox;
        ConvertFromStr(value: string): void;
        ConvertToStr(): string;
        CopyFrom(source: BoundingBox): void;
        static CreateMerged(original: BoundingBox, additional: BoundingBox, result?: BoundingBox): BoundingBox;
        SetCreateMerged(original: BoundingBox, additional: BoundingBox): BoundingBox;
        static CreateFromSphere(sphere: BoundingSphere, result?: BoundingBox): BoundingBox;
        SetCreateFromSphere(sphere: BoundingSphere): BoundingBox;
        static CreateFromPoints(points: Array<Vector3>, result?: BoundingBox): BoundingBox;
        SetCreateFromPoints(points: Array<Vector3>): BoundingBox;
        IntersectsBoundingBox(box: BoundingBox): boolean;
        IntersectsBoundingFrustum(frustum: BoundingFrustum): boolean;
        IntersectsPlane(plane: Plane): PlaneIntersectionTypeEnum;
        IntersectsRay(ray: Ray3): number;
        IntersectsBoundingSphere(sphere: BoundingSphere): boolean;
        ContainsBoundingBox(box: BoundingBox): ContainmentTypeEnum;
        ContainsBoundingFrustum(frustum: BoundingFrustum): ContainmentTypeEnum;
        ContainsPoint(point: Vector3): ContainmentTypeEnum;
        ContainsBoundingSphere(sphere: BoundingSphere): ContainmentTypeEnum;
        SupportMapping(v: Vector3): Vector3;
        private static _cache;
        static New(): BoundingBox;
        static Release(v: BoundingBox): void;
        Release(): void;
    }
    class BoundingSphere implements U1.IUValue {
        Center: Vector3;
        Radius: number;
        ConvertFromStr(value: string): void;
        ConvertToStr(): string;
        Equals(other: BoundingSphere): boolean;
        Clone(): BoundingSphere;
        CopyFrom(source: BoundingSphere): void;
        constructor(center?: Vector3, radius?: number);
        static CreateMerged(original: BoundingSphere, additional: BoundingSphere, result?: BoundingSphere): BoundingSphere;
        SetCreateMerged(original: BoundingSphere, additional: BoundingSphere): BoundingSphere;
        static CreateFromBoundingBox(box: BoundingBox, result?: BoundingSphere): BoundingSphere;
        SetCreateFromBoundingBox(box: BoundingBox): BoundingSphere;
        static CreateFromPoints(points: Array<Vector3>, result?: BoundingSphere): BoundingSphere;
        SetCreateFromPoints(points: Array<Vector3>): BoundingSphere;
        static CreateFromFrustum(frustum: BoundingFrustum, result?: BoundingSphere): BoundingSphere;
        SetCreateFromFrustum(frustum: BoundingFrustum): BoundingSphere;
        IntersectsBoundingBox(box: BoundingBox): boolean;
        IntersectsBoundingFrustum(frustum: BoundingFrustum): boolean;
        IntersectsPlane(plane: Plane): PlaneIntersectionTypeEnum;
        Intersects(ray: Ray3): number;
        IntersectsBoundingSphere(sphere: BoundingSphere): boolean;
        ContainsBoundingBox(box: BoundingBox): ContainmentTypeEnum;
        ContainsBoundingFrustum(frustum: BoundingFrustum): ContainmentTypeEnum;
        ContainsPoint(point: Vector3): ContainmentTypeEnum;
        ContainsBoundingSphere(sphere: BoundingSphere): ContainmentTypeEnum;
        SupportMapping(v: Vector3, result?: Vector3): Vector3;
        static Transform(src: BoundingSphere, matrix: Matrix4, result?: BoundingSphere): BoundingSphere;
        Transform(matrix: Matrix4, result?: BoundingSphere): BoundingSphere;
        private static _cache;
        static New(): BoundingSphere;
        static Release(v: BoundingSphere): void;
        Release(): void;
    }
    class Ray2 implements U1.IUValue {
        Position: Vector2;
        Direction: Vector2;
        constructor(position?: Vector2, direction?: Vector2);
        Clone(): Ray2;
        ConvertFromStr(value: string): void;
        ConvertToStr(): string;
        CopyFrom(source: Ray2): void;
        Equals(other: Ray2): boolean;
        static DistanceSquared(ray: Ray2, pt: Vector2): number;
        static Distance(ray: Ray2, pt: Vector2): number;
        private static _cache;
        static New(): Ray2;
        static Release(v: Ray2): void;
        Release(): void;
    }
    class Ray3 implements U1.IUValue {
        Position: Vector3;
        Direction: Vector3;
        ConvertFromStr(value: string): void;
        ConvertToStr(): string;
        Equals(other: Ray3): boolean;
        CopyFrom(other: Ray3): Ray3;
        Clone(): Ray3;
        constructor(position?: Vector3, direction?: Vector3);
        IntersectsBoundingBox(box: BoundingBox): number;
        IntersectsBoundingFrustum(frustum: BoundingFrustum): number;
        IntersectsPlane(plane: Plane): number;
        IntersectsBoundingSphere(sphere: BoundingSphere): number;
        static DistanceSquared(ray: Ray3, point: Vector3): number;
        Transform(matrix: Matrix4): Ray3;
        private static _cache;
        static New(): Ray3;
        static Release(v: Ray3): void;
        Release(): void;
    }
    class BoundingFrustum {
        static CornerCount: number;
        private static NearPlaneIndex;
        private static FarPlaneIndex;
        private static LeftPlaneIndex;
        private static RightPlaneIndex;
        private static TopPlaneIndex;
        private static BottomPlaneIndex;
        private static NumPlanes;
        private gjk;
        private matrix;
        private cornerArray;
        private planes;
        constructor(value?: Matrix4);
        Equals(other: BoundingFrustum): boolean;
        private static ComputeIntersection(plane, ray, result?);
        static ComputeIntersectionLine(p1: Plane, p2: Plane, result?: Ray3): Ray3;
        ContainsBoundingBox(box: BoundingBox): ContainmentTypeEnum;
        ContainsBoundingFrustum(frustum: BoundingFrustum): ContainmentTypeEnum;
        ContainsBoundingSphere(sphere: BoundingSphere): ContainmentTypeEnum;
        ContainsPoint(point: Vector3): ContainmentTypeEnum;
        CornerArray: Vector3[];
        GetCornersCopy(): Vector3[];
        private static tmp_v3_0;
        private static tmp_v3_1;
        private static tmp_v3_2;
        private static tmp_v3_3;
        private static tmp_box_points;
        IntersectsBoundingBox(box: BoundingBox): boolean;
        IntersectsBoundingFrustum(frustum: BoundingFrustum): boolean;
        IntersectsBoundingSphere(sphere: BoundingSphere): boolean;
        IntersectsPlane(plane: Plane): PlaneIntersectionTypeEnum;
        IntersectsRay(ray: Ray3): number;
        SupportMapping(v: Vector3): Vector3;
        SetMatrix(value: Matrix4): void;
        Bottom: Plane;
        Far: Plane;
        Left: Plane;
        Near: Plane;
        Right: Plane;
        Top: Plane;
        Matrix: Matrix4;
    }
    enum ProjectionTypeEnum {
        Perspective = 0,
        Orthographic = 1,
    }
    class OrientedBox3 {
        Axes: Vector3[];
        Center: Vector3;
        Extents: number[];
        CopyFrom(src: OrientedBox3): void;
        Radius: number;
        IsEmpty: boolean;
        Clone(): OrientedBox3;
        static Empty: OrientedBox3;
        static Identity: OrientedBox3;
        static CheckIntersect(rkBox0: OrientedBox3, rkBox1: OrientedBox3): boolean;
        static GetOrientMatrix(obx: OrientedBox3, result?: Matrix4): Matrix4;
        static GetMatrix(obx: OrientedBox3, result?: Matrix4): Matrix4;
        GetMatrix(result?: Matrix4): Matrix4;
        GetOrientMatrix(result?: Matrix4): Matrix4;
        LFB(result?: Vector3): Vector3;
        LKB(result?: Vector3): Vector3;
        LFT(result?: Vector3): Vector3;
        LKT(result?: Vector3): Vector3;
        RFB(result?: Vector3): Vector3;
        RKB(result?: Vector3): Vector3;
        RFT(result?: Vector3): Vector3;
        RKT(result?: Vector3): Vector3;
        FrontPlane(result?: Plane): Plane;
        BackPlane(result?: Plane): Plane;
        RightPlane(result?: Plane): Plane;
        LeftPlane(result?: Plane): Plane;
        TopPlane(result?: Plane): Plane;
        BottomPlane(result?: Plane): Plane;
        GetVs(points: Vector3[]): Vector3[];
        private GetVertex(s0, s1, s2, result?);
        static Transform(source: OrientedBox3, matrix: Matrix4, result: OrientedBox3): OrientedBox3;
        Transform(matrix: Matrix4): OrientedBox3;
        SetTransform(source: OrientedBox3, matrix: Matrix4): OrientedBox3;
        ScaleWithTwoPoints(cent: Vector3, p0: Vector3, p1: Vector3): OrientedBox3;
        Scale(cent: Vector3, axisScale: Vector3): OrientedBox3;
        SetScale(source: OrientedBox3, cent: Vector3, axisScale: Vector3): OrientedBox3;
        SetScaleWithTowPoints(source: OrientedBox3, cent: Vector3, p0: Vector3, p1: Vector3): OrientedBox3;
        static Rotate(source: OrientedBox3, center: Vector3, axis: Vector3, angle: number): OrientedBox3;
        static Translate(source: OrientedBox3, offset: Vector3): OrientedBox3;
        static GetMatrixBetween(from: OrientedBox3, to: OrientedBox3): Matrix4;
        Rotate(source: OrientedBox3, center: Vector3, axis: Vector3, angle: number): OrientedBox3;
        SetRotate(source: OrientedBox3, center: Vector3, axis: Vector3, angle: number): OrientedBox3;
        private static _cache;
        static New(): OrientedBox3;
        static Release(v: OrientedBox3): void;
        Release(): void;
    }
    enum LightTypeEnum {
        D3DLIGHT_POINT = 1,
        D3DLIGHT_SPOT = 2,
        D3DLIGHT_DIRECTIONAL = 3,
        D3DLIGHT_FORCE_DWORD = 2147483647,
    }
    class Light implements U1.IUValue {
        Type: LightTypeEnum;
        Diffuse: Color;
        Specular: Color;
        Ambient: Color;
        Position: Vector3;
        Direction: Vector3;
        Range: number;
        Falloff: number;
        Attenuation0: number;
        Attenuation1: number;
        Attenuation2: number;
        Theta: number;
        Phi: number;
        Clone(): Light;
        ConvertFromStr(value: string): void;
        ConvertToStr(): string;
        CopyFrom(source: Light): void;
        Equals(source: Light): boolean;
    }
    class Color implements U1.IUValue {
        A: number;
        R: number;
        G: number;
        B: number;
        ConvertFromStr(value: string): void;
        ConvertToStr(): string;
        Equals(other: Color): boolean;
        CopyFrom(other: Color): void;
        Clone(): Color;
        constructor(r?: number, g?: number, b?: number, a?: number);
        static FromUInt32(argb: number): Color;
        toString(): string;
        private static _cache;
        static New(): Color;
        static Release(v: Color): void;
        Release(): void;
    }
    class Line2 {
        /**
        * 라인위의 한점
        */
        Position: Vector2;
        /**
        * 라인 방향
        */
        Direction: Vector2;
        ConvertFromStr(value: string): void;
        ConvertToStr(): string;
        Equals(other: Line2): boolean;
        constructor(position?: Vector2, direction?: Vector2);
        CopyFrom(line2: Line2): void;
        CopyFromRay(ray: Ray2): void;
        static GetIntersectPoint(line0: Line2, line1: Line2, result?: Vector2): Vector2;
        static GetIntersectInfo(line0: Line2, line1: Line2, result?: {
            IsectP: Vector2;
            s: number;
            t: number;
        }): {
            IsectP: Vector2;
            s: number;
            t: number;
        };
        static DistanceSquared(line: Line2, point: Vector2): number;
    }
    class Segment2 {
        /**
        * 시작점
        */
        Start: Vector2;
        /**
        * 끝점
        */
        End: Vector2;
        ConvertFromStr(value: string): void;
        ConvertToStr(): string;
        constructor(start: Vector2, end: Vector2);
        Equals(other: Segment2): boolean;
        static CheckCross(seg0: Segment2, seg1: Segment2): Vector2;
        static IsIntersectPolylines(source: Vector2[], target: Vector2[]): boolean;
        static DistanceSquaredPoint(segment: Segment2, point: Vector2): number;
        static DistancePoint(segment: Segment2, point: Vector2): number;
    }
    class Circle2 {
        /**
        * 중심
        */
        Center: Vector2;
        /**
        * 반지름
        */
        Radius: number;
        Circle2(center?: Vector2, radius?: number): void;
        Equals(other: Circle2): boolean;
        static IsIntersectPolyline(center: Vector2, sqRadius: number, path: Array<Vector2>): boolean;
        static IsIntersectPolygon(center: Vector2, sqRadius: number, path: Array<Vector2>): boolean;
    }
    class GeometryHelper2 {
        static AngleBetween(start: Vector2, end: Vector2): number;
        static AngleCCW(baseAxis: Vector2, vector: Vector2): number;
        static CrossLineLine(s0: Vector2, sd: Vector2, t0: Vector2, td: Vector2): {
            s: number;
            t: number;
        };
        static CrossSegSeg(s0: Vector2, s1: Vector2, t0: Vector2, t1: Vector2, SAME_DIST?: number): {
            ss: number[];
            ts: number[];
        };
        static CrossCircleCircle(circle0: Circle2, circle1: Circle2): Vector2[];
        static CrossSegmentSegment(segment0: Segment2, segment1: Segment2): Vector2[];
        static CrossLineCircle(line: Line2, circle: Circle2): Vector2[];
        static CrossSegmentCircle(segment: Segment2, circle: Circle2): Vector2[];
    }
    class GeometryHelper3 {
        static AngleCCW(baseVector: Vector3, planeNormal: Vector3, vector: Vector3): number;
        static PolygonNormal(points: Array<Vector3>, start: number, length: number, normalize: boolean, res_normal: Vector3): boolean;
        static GetArbitraryAxis(normal: Vector3, udir: Vector3, vdir: Vector3): void;
        static GetRotationM2M(src: Matrix4, target: Matrix4): {
            axis: Vector3;
            angle: number;
            roll: number;
        };
        private static tmp_v30;
        private static tmp_v31;
    }
    class Arc2 {
        private _start;
        private _end;
        private _center;
        private _bulge;
        private _isCenterDirty;
        Tag: any;
        constructor(start?: Vector2, end?: Vector2, bulge?: number);
        CopyFrom(src: Arc2): void;
        static Zero: Arc2;
    }
    class Line3 {
        Position: Vector3;
        Direction: Vector3;
        constructor(position?: Vector3, direction?: Vector3);
        static SquardDistance(line0: Line3, line1: Line3, result: {
            s: number;
            t: number;
        }): number;
        static SquardDistance1(p0: Vector3, d0: Vector3, p1: Vector3, d1: Vector3, result: {
            s: number;
            t: number;
        }): number;
        Release(): void;
        private static _cache;
        static New(): Line3;
        static Release(v: Line3): void;
    }
    class Viewport {
        static PRECISION: number;
        X: number;
        Y: number;
        Width: number;
        Height: number;
        MinDepth: number;
        MaxDepth: number;
        toString(): string;
        Project(source: Vector3, projection: Matrix4, view: Matrix4, world: Matrix4): Vector3;
        ProjectWVP(source: Vector3, wvp: Matrix4): Vector3;
        Unproject(source: Vector3, projection: Matrix4, view: Matrix4, world: Matrix4): Vector3;
        AspectRatio: number;
        static Project(source: Vector3, projection: Matrix4, view: Matrix4, world: Matrix4, minDepth: number, maxDepth: number, x: number, y: number, width: number, heiht: number): Vector3;
        Equals(other: Viewport): boolean;
    }
    class Camera {
        Position: Vector3;
        LookAt: Vector3;
        Up: Vector3;
        FOV: number;
        Near: number;
        Far: number;
        OrthoHeight: number;
        ProjectionMode: ProjectionTypeEnum;
        Viewport: Viewport;
        private _BoundingFrustum;
        Frustum: BoundingFrustum;
        Right: Vector3;
        Direction: Vector3;
        ProjMatrix: Matrix4;
        ViewMatrix: Matrix4;
        Aspect: number;
        static Default: Camera;
        CalPickingRay(x: number, y: number): Ray3;
        WorldToScreen(wp: Vector3): Vector3;
        ScreenToWorld(sp: Vector3): Vector3;
        GetRotation(targetCamera: Camera): {
            axis: Vector3;
            angle: number;
            roll: number;
        };
        static GetRotation(src: Matrix4, target: Matrix4): {
            axis: Vector3;
            angle: number;
            roll: number;
        };
        Roll(roll: number): void;
        Rotate(position: Vector3, axis: Vector3, ang: number): void;
        ScreenToPlane(pt: Vector2, plane: Plane): Vector3;
        Move(dir: Vector3): void;
        Clone(): Camera;
        Equals(other: Camera): boolean;
    }
    class Rectangle {
        static Empty: Rectangle;
        private x;
        private y;
        private width;
        private height;
        constructor(x?: number, y?: number, width?: number, height?: number);
        X: number;
        Y: number;
        Width: number;
        Height: number;
        Left: number;
        Top: number;
        Right: number;
        Bottom: number;
        IsEmpty: boolean;
        Equals(obj: any): boolean;
        Contains(x: number, y: number): boolean;
        ContainsRect(rect: Rectangle): boolean;
        GetHashCode(): number;
        Inflate(width: number, height: number): void;
        static Inflate(rect: Rectangle, x: number, y: number): Rectangle;
        Intersect(rect: Rectangle): void;
        static Intersect(a: Rectangle, b: Rectangle): Rectangle;
        IntersectsWith(rect: Rectangle): boolean;
        static Union(a: Rectangle, b: Rectangle): Rectangle;
        Union(b: Rectangle): void;
        Offset(x: number, y: number): void;
        toString(): string;
    }
}
declare namespace U1 {
    enum UVariantTypes {
        Number = 0,
        Bool = 1,
        String = 2,
        Vector = 3,
        Matrix = 4,
    }
    enum UOperationType {
        None = 0,
        Logical_Or = 1,
        Logical_And = 2,
        Equal = 3,
        NotEqual = 4,
        Less = 5,
        Great = 6,
        LessEqual = 7,
        GreatEqual = 8,
        Add = 9,
        Sub = 10,
        Multiply = 11,
        Divide = 12,
        Parenthesis = 13,
        Dot = 14,
        Index = 15,
    }
    class UVariant {
        VariantType: UVariantTypes;
        private _value;
        Value: Object;
        constructor();
        static Zero: UVariant;
        SetNumber(value: number): this;
        SetBool(value: boolean): this;
        SetString(value: string): this;
        SetVector(value: number[]): this;
        SetMatrix(value: number[][]): this;
        CopyFrom(src: UVariant): this;
        SetColor(color: Color): this;
        SetVector2(vector: Vector2): this;
        SetVector3(vector: Vector3): this;
        SetVector4(vector: Vector4): this;
        ItemCount: number;
        GetNumber(): number;
        GetBool(): boolean;
        GetString(): string;
        private GetNumberAt(idx);
        toString(): string;
        GetNumbers(): number[];
        GetNumber2(): number[];
        GetNumber3(): number[];
        GetNumber4(): number[];
        /**
        * Return Matrix4x4
        */
        GetMatrix(): number[][];
        GetVector2(): Vector2;
        GetVector3(): Vector3;
        GetVector4(): Vector4;
        GetColor(): Color;
        static ToString(expVar: UVariant): string;
        static FromString(variantString: string): UVariant;
        static Negate(value: UVariant): UVariant;
        static Add(value1: UVariant, value2: UVariant): UVariant;
        static Sub(value1: UVariant, value2: UVariant): UVariant;
        static Multiply(value1: UVariant, value2: UVariant): UVariant;
        static Divide(value1: UVariant, value2: UVariant): UVariant;
        private static VectorOperation(op, value1, value2);
        private static MatrixOperation(op, value1, value2);
        static Transform(expValue: UVariant, func: (a: number) => number): UVariant;
        static Transform2(expValue1: UVariant, expValue2: UVariant, func: (a: number, b: number) => number): UVariant;
        static ToColor(expVariant: UVariant): Color;
        static ToVector3(expVariant: UVariant): Vector3;
        static ToVector2(expVariant: UVariant): Vector2;
        static ToVector4(expVariant: UVariant): Vector4;
        Equals(other: UVariant): boolean;
    }
}
declare namespace U1 {
    interface IUPropertyBaseArgs {
        Source?: any;
        SourceProperty?: string;
        Category?: string;
        Group?: string;
        Name?: string;
        Label?: string;
        ValueText?: string;
        IsEditable?: boolean;
        DisposingAction?: (prop: UPropertyBase) => any;
        IsVisible?: boolean;
        Tag?: any;
        Background?: string;
        GetIsVibible?: (prop: UPropertyBase) => boolean;
    }
    class UPropertyBase {
        protected _valueText: string;
        private _label;
        protected _category: string;
        protected _group: string;
        protected _name: string;
        protected _sourceProp: string;
        protected _source: any;
        protected _isDisposed: boolean;
        protected _isReadOnly: boolean;
        protected _isVisible: boolean;
        protected _tag: any;
        protected _childProps: UPropertyBase[];
        protected _document: UDocument;
        protected _backGround: string;
        private static _key;
        private _key;
        constructor(arg?: IUPropertyBaseArgs);
        DisposingAction: (prop: UPropertyBase) => any;
        GetIsVibible: (prop: UPropertyBase) => boolean;
        Key: string;
        Source: any;
        IsDisposed: boolean;
        SourceProperty: string;
        Category: string;
        /**
        * 그룹 이름을 설정하거나 가져온다. null인 경우 카테고리 차일드로 등록된다.
        */
        Group: string;
        Name: string;
        Label: string;
        LabelColon: string;
        ValueText: string;
        IsReadOnly: boolean;
        IsEditable: boolean;
        IsVisible: boolean;
        Tag: any;
        ChildProperties: UPropertyBase[];
        Background: string;
        GetSourceAll<T extends UPropertyBase>(ctr: {
            new (): T;
        }): Array<T>;
        AddChild(other: UPropertyBase): void;
        PropertyChanged: PropertyChangedEvent;
        protected InvokeValueChanged(): void;
        InvokePropertyChanged(name?: string): void;
        Dispose(): void;
        protected OnDisposing(): void;
        private AddSourceEventHandlers();
        OnPropertyChanged(sender: any, propName: string): void;
        private RemoveSourceEventHandlers();
        private AddDocumentEventHandlers();
        private RemoveDocumentEventHandlers();
        protected OnDocument_AfterUndoRedo(arg1: UDocument, arg2: boolean): void;
        protected OnDocument_AfterEndTransaction(obj: UDocument): void;
        protected OnElementDisposing(sender: UElement): void;
    }
    interface IUPropertyArgs<T> extends IUPropertyBaseArgs {
        GetValueFunc?: (a: UProperty<T>) => T;
        SetValueFunc?: (a: UProperty<T>, value: T) => any;
        BeginChangeFunc?: (a: UProperty<T>) => any;
        EndChangeFunc?: (a: UProperty<T>) => any;
    }
    class UProperty<T> extends UPropertyBase {
        GetValueFunc: (a: UProperty<T>) => T;
        SetValueFunc: (a: UProperty<T>, value: T) => any;
        BeginChangeFunc: (a: UProperty<T>) => any;
        EndChangeFunc: (a: UProperty<T>) => any;
        constructor(arg?: IUPropertyArgs<T>);
        protected _value: T;
        protected _parent: UProperty<T>;
        protected _children: Array<UProperty<T>>;
        ValueText: string;
        TheValue: T;
        Value: T;
        protected setValue(value: T): void;
        Parent: UProperty<T>;
        Children: Array<UProperty<T>>;
        IsReadOnly: boolean;
        AddChild(other: UPropertyBase): void;
        protected InvokeValueChanged(): void;
        protected OnDisposing(): void;
        protected EndTransaction(): void;
        protected BeginTransaction(): void;
    }
    class UPropBool extends UProperty<boolean> {
        constructor(arg?: IUPropertyArgs<boolean>);
        ValueText: string;
    }
    class UPropString extends UProperty<string> {
        private _acceptsReturn;
        constructor(arg?: IUPropertyArgs<string>);
        AcceptsReturn: boolean;
    }
    class UPropDouble extends UProperty<number> {
        protected increment: number;
        protected formatString: string;
        constructor(arg?: IUPropertyArgs<number>);
        FromDisplay(str: string): number;
        ToDisplay(len: number): string;
        FormatString: string;
        Increment: number;
        Value: number;
        ValueText: string;
    }
    class UPropInt extends UPropDouble {
        constructor(arg?: IUPropertyArgs<number>);
    }
}
declare namespace U1 {
    class UPropContainer extends UPropertyBase {
        protected static s_isExpandeds: {
            [index: string]: boolean;
        };
        protected _items: UPropertyBase[];
        Items: UPropertyBase[];
        ParentContainer: UPropContainer;
        Path: any;
        IsExpanded: boolean;
        InvokePropertyChanged(prop?: string): void;
        AddChild(other: UPropertyBase): void;
        protected OnDisposing(): void;
    }
}
declare namespace U1 {
    class UPropCategory extends UPropContainer {
        CategoryGroup: UPropCategoryGroup;
        static Categorize(props: UPropertyBase[]): UPropCategory[];
        Path: string;
    }
}
declare namespace U1 {
    class UPropCategoryGroup extends UPropContainer {
        private static MaxCount;
        Path: string;
        Categories: UPropCategory[];
        static Categorize(selection: any[]): Array<UPropCategoryGroup>;
    }
}
declare namespace U1 {
    class UPropertySelection extends UProperty<string> {
        private _items;
        Items: string[];
    }
}
declare namespace U1 {
    class UPropGroup extends UPropContainer {
    }
}
declare namespace U1 {
    class UValueIntArr implements IUValue {
        private values;
        Value: number[];
        ConvertFromStr(value: string): void;
        ConvertToStr(): string;
        Equals(other: UValueIntArr): boolean;
        Clone(): UValueIntArr;
        CopyFrom(other: UValueIntArr): void;
    }
    class UValueNumArr implements IUValue {
        private values;
        ConvertFromStr(value: string): void;
        ConvertToStr(): string;
        Equals(other: UValueNumArr): boolean;
        Clone(): UValueNumArr;
        CopyFrom(other: UValueNumArr): void;
    }
    class UFieldAny {
        protected m_old: any;
        protected m_cur: any;
        protected m_isChanged: boolean;
        constructor(val?: any);
        /**
        * 현재값을 가져옴
        */
        GetCurrent(owner: U1.UElement): any;
        /**
        *현재값을 지정
        *@param {U1.UElement} owner = 속성의 소유자
        *@param {string} prop_name = 속성의 이름
        *@param {any} val = 속성에 설정할 값
        */
        SetCurrent(owner: U1.UElement, prop_name: string, val: any): void;
        IsChanged: boolean;
        CurRawData: any;
        /**
        * 변경된 값을 적용
        * 이전값이 현재값과 같도록 변경
        */
        AcceptChange(owner: U1.UElement, prop_name: string): void;
        /**
        * 변경 취소
        * 현재값이 이전값과 같도록 변경
        */
        CancelChange(owner: U1.UElement, prop_name: string): void;
        /**
        * 문자열로 변환된 속성을 설정
        */
        ConvertFromStr(owner: U1.UElement, prop: string, value: string): void;
        /**
        * 파일로 저장된 문자열에서 속성 읽어옴
        */
        LoadFromStr(owner: U1.UElement, prop: string, value: string): void;
        /**
        * 현재값을 문자열로 변환
        */
        ConvertToStr(): string;
        /**
        * 현재값을 파일로 저장할 문자열 변환
        */
        ConvertToStrSave(): string;
        /**
        * 이전값을 문자열로 변환
        */
        ConvertOldTo(): string;
        protected MarkChanged(owner: U1.UElement, prop_name: string): void;
    }
    class UFieldBool extends UFieldAny {
        constructor(val: boolean);
        GetCurrent(owner: U1.UElement): boolean;
        SetCurrent(owner: U1.UElement, prop_name: string, val: boolean): void;
        ConvertFromStr(owner: U1.UElement, prop_name: string, value: string): void;
    }
    class UFieldInt extends UFieldAny {
        constructor(val: number);
        GetCurrent(owner: U1.UElement): number;
        SetCurrent(owner: U1.UElement, prop_name: string, val: number): void;
        ConvertFromStr(owner: U1.UElement, prop_name: string, value: string): void;
        ConvertToStr(): string;
    }
    class UFieldIntArr extends UFieldAny {
        constructor(val: number[]);
        IsChanged: boolean;
        GetCurrent(owner: U1.UElement): number[];
        SetCurrent(owner: U1.UElement, prop_name: string, val: number[]): void;
        ConvertFromStr(owner: U1.UElement, prop: string, value: string): void;
        ConvertToStr(): string;
        ConvertOldTo(): string;
        /**
        * 변경된 값을 적용
        * 이전값이 현재값과 같도록 변경
        */
        AcceptChange(owner: U1.UElement, prop_name: string): void;
        /**
        * 변경 취소
        * 현재값이 이전값과 같도록 변경
        */
        CancelChange(owner: U1.UElement, prop_name: string): void;
        Equals(a: number[], b: number[]): boolean;
    }
    class UFieldFloat extends UFieldAny {
        constructor(val: number);
        GetCurrent(owner: U1.UElement): number;
        SetCurrent(owner: U1.UElement, prop_name: string, val: number): void;
        ConvertFromStr(owner: U1.UElement, prop: string, value: string): void;
    }
    class UFieldFloatArr extends UFieldAny {
        constructor(val: number[]);
        IsChanged: boolean;
        GetCurrent(owner: U1.UElement): number[];
        SetCurrent(owner: U1.UElement, prop_name: string, val: number[]): void;
        ConvertFromStr(owner: U1.UElement, prop: string, value: string): void;
        ConvertToStr(): string;
        ConvertOldTo(): string;
        /**
        * 변경된 값을 적용
        * 이전값이 현재값과 같도록 변경
        */
        AcceptChange(owner: U1.UElement, prop_name: string): void;
        /**
        * 변경 취소
        * 현재값이 이전값과 같도록 변경
        */
        CancelChange(owner: U1.UElement, prop_name: string): void;
        Equals(a: number[], b: number[]): boolean;
    }
    class UFieldStr extends UFieldAny {
        constructor(val: string);
        GetCurrent(owner: U1.UElement): string;
        SetCurrent(owner: U1.UElement, prop_name: string, val: string): void;
        ConvertFromStr(owner: U1.UElement, prop: string, value: string): void;
    }
    class UFieldStrArr extends UFieldAny {
        constructor(val: string[]);
        IsChanged: boolean;
        GetCurrent(owner: U1.UElement): string[];
        SetCurrent(owner: U1.UElement, prop_name: string, val: string[]): void;
        ConvertFromStr(owner: U1.UElement, prop: string, value: string): void;
        ConvertToStr(): string;
        ConvertOldTo(): string;
        Equals(a: string[], b: string[]): boolean;
    }
    /**
    * 긴 문자열
    * 저장시 base64로 저장됨
    */
    class UFieldLStr extends UFieldStr {
        constructor(val: string);
        LoadFromStr(owner: U1.UElement, prop: string, value: string): void;
        ConvertToStrSave(): string;
    }
    /**
    * 이미지등 binary 데이터
    * base64형태로 지님
    */
    class UFieldXData extends UFieldStr {
        constructor(val: string);
    }
    class UField<T extends IUValue> extends UFieldAny {
        constructor(val: T);
        Creater: {
            new (): T;
        };
        GetCurrent(owner: U1.UElement): T;
        SetCurrent(owner: U1.UElement, prop_name: string, val: T): void;
        ConvertFromStr(owner: U1.UElement, prop: string, value: string): void;
        ConvertToStr(): string;
        ConvertOldTo(): string;
        /**
        * 변경된 값을 적용
        * 이전값이 현재값과 같도록 변경
        */
        AcceptChange(owner: U1.UElement, prop_name: string): void;
        /**
        * 변경 취소
        * 현재값이 이전값과 같도록 변경
        */
        CancelChange(owner: U1.UElement, prop_name: string): void;
    }
    class UFieldArr<T extends IUValue> extends UFieldAny {
        private val_ctor;
        constructor(c: {
            new (): T;
        }, val: T[]);
        GetCurrent(owner: U1.UElement): T[];
        SetCurrent(owner: U1.UElement, prop_name: string, val: T[]): void;
        ConvertFromStr(owner: U1.UElement, prop: string, value: string): void;
        ConvertToStr(): string;
        ConvertOldTo(): string;
        /**
        * 변경된 값을 적용
        * 이전값이 현재값과 같도록 변경
        */
        AcceptChange(owner: U1.UElement, prop_name: string): void;
        /**
        * 변경 취소
        * 현재값이 이전값과 같도록 변경
        */
        CancelChange(owner: U1.UElement, prop_name: string): void;
        Equals(a: T[], b: T[]): boolean;
    }
    class UFieldRef<T extends U1.UElement> extends UFieldAny {
        private _cur_value;
        constructor(val?: T);
        GetCurrent(owner: U1.UElement): T;
        SetCurrent(owner: U1.UElement, prop_name: string, value?: T): void;
        UpdateReference(owner: U1.UElement, prop_name: string): void;
        ConvertFromStr(owner: U1.UElement, prop: string, value: string): void;
        ConvertToStr(): string;
        ConvertOldTo(): string;
        AcceptChange(owner: U1.UElement, prop_name: string): void;
        /**
        * 변경 취소
        * 현재값이 이전값과 같도록 변경
        */
        CancelChange(owner: U1.UElement, prop_name: string): void;
        ReplaceRef(owner: U1.UElement, prop_name: string, id_map: {
            [index: number]: number;
        }): boolean;
    }
    class UFieldRefArr<T extends U1.UElement> extends UFieldAny {
        private _cur_value;
        constructor(val?: T[]);
        GetCurrent(owner: U1.UElement): T[];
        SetCurrent(owner: U1.UElement, prop_name: string, val?: T[]): void;
        ConvertFromStr(owner: U1.UElement, prop: string, value: string): void;
        ConvertToStr(): string;
        ConvertOldTo(): string;
        /**
        * 변경된 값을 적용
        * 이전값이 현재값과 같도록 변경
        */
        AcceptChange(owner: U1.UElement, prop_name: string): void;
        /**
        * 변경 취소
        * 현재값이 이전값과 같도록 변경
        */
        CancelChange(owner: U1.UElement, prop_name: string): void;
        UpdateReference(owner: U1.UElement, prop_name: string): void;
        ReplaceRef(owner: U1.UElement, prop_name: string, id_map: {
            [index: number]: number;
        }): boolean;
        Equals(a: number[], b: number[]): boolean;
    }
}
declare namespace U1 {
    class ElementData {
        ElementType: string;
        Values: {
            [index: string]: any;
        };
        constructor(element: U1.UElement);
    }
    class RefLink {
        Source: number;
        SourceProp: string;
        Target: number;
        NextSource: RefLink;
        NextTarget: RefLink;
        PrevTarget: RefLink;
        constructor(src_id: number, src_prop: string, tgt_id: number);
        toString(): string;
        RemoveTargetLink(): void;
        AddNextTarget(target: RefLink): void;
        AddNextSource(source: RefLink): void;
        Dispose(): void;
        NextSourceAll(): Array<RefLink>;
        NextTargetAll(): Array<RefLink>;
    }
    class UElementTable {
        static Creaters: {
            [index: string]: {
                new (): U1.UElement;
            };
        };
        static Register(name: string | {
            new (): U1.UElement;
        }, c?: {
            new (): U1.UElement;
        }): void;
        private static m_elementsConstructors;
        private document;
        private m_elements;
        private m_elementsByTypes;
        private m_changedElements;
        private m_next_id;
        private static key_count;
        private static mask_ref_key;
        private m_refer_table;
        constructor(doc: U1.UDocument);
        Document: U1.UDocument;
        SetChanged(elem: U1.UElement): void;
        SetUnChanged(elem: U1.UElement): void;
        /**
           * 변경된 요소들을 가져옴
        */
        ChangedElements: Array<U1.UElement>;
        HasChangedElements: boolean;
        GetElement<T extends U1.UElement>(id: number): T;
        GetElements(): Array<UElement>;
        AddElement<T extends UElement>(c: {
            new (): T;
        }): T;
        AddElementWithData<T extends UElement>(c: {
            new (): T;
        }, data?: any): T;
        Remove(element: UElement): void;
        private idArrOne;
        GetReferTargets(source: number): Array<number>;
        GetReferSources(target: number): Array<number>;
        GetReferSourcesBySrcProp(target: number, srcProp: string): Array<number>;
        UpdateReference(source: U1.UElement, sourceProp: string, targetID: number): void;
        UpdateReferences(source: U1.UElement, sourceProp: string, targetIDs?: number[]): void;
        CreateInstance(data: {
            [index: string]: string;
        }, isLoading?: boolean): UElement;
        private static last_type_id;
        Add(instance: UElement): void;
        AbortChange(): void;
        AcceptChange(): void;
        Clear(): void;
    }
}
declare namespace U1 {
    enum ElementStates {
        Old = 0,
        New = 1,
        Detached = 2,
        Modified = 3,
        Deleted = 4,
    }
    class FieldSet {
        Fields: Array<{
            name: string;
            field: U1.UFieldAny;
        }>;
        Owner: U1.UElement;
        constructor(owner: U1.UElement);
        AddField(name: string, field: U1.UFieldAny): void;
        SetCurData(data: {
            name: string;
            value: string;
        }): void;
    }
    class UElement {
        id: number;
        private document;
        private state;
        private isDeleted;
        private isDisposed;
        private flag;
        private _PropertyChanged;
        private _BeforeDispose;
        Fields: {
            [index: string]: U1.UFieldAny;
        };
        PropertyChanged: PropertyChangedEvent;
        BeforeDispose: Event1<UElement>;
        constructor();
        ID: number;
        Document: U1.UDocument;
        ElementTable: U1.UElementTable;
        State: ElementStates;
        IsDeleting: boolean;
        IsDisposed: boolean;
        IsDeleted: boolean;
        Dispose(): void;
        OnDisposing(): void;
        Disposing(isDisposing: boolean): void;
        Delete(): void;
        ForceDelete(): void;
        AcceptChange(): void;
        CancelChange(): void;
        /**
        * 가상메소드, 상태가 변경되면 호출됨
        */
        OnStateChanged(): void;
        private OnAcceptChange();
        private OnCancelChange();
        GetTypeName(): string;
        MarkModified(): void;
        GetOldData(fChangedOnly?: boolean): {
            [index: string]: string;
        };
        GetCurData(fChangedOnly?: boolean): {
            [index: string]: string;
        };
        SetCurData(data: {
            [index: string]: string;
        }, isLoading?: boolean): void;
        GetFields(): FieldSet;
        /**
        * 요소의 모든 필드들을 가져옴, 가상메소드
        */
        OnGetFields(fieldSet: U1.FieldSet): void;
        OnDeleting(): void;
        OnRefDeleting(element: U1.UElement): void;
        private __fields;
        protected Field<T extends UFieldAny>(ctr: {
            new (val: any): T;
        }, prop: string, def?: any): UFieldAny;
        protected UpdateRefs(id_map: {
            [index: number]: number;
        }): void;
        InvokePropertyChanged(prop: string): void;
        PropertyCategory: string;
        GetProperties(): UPropertyBase[];
    }
}
declare namespace U1 {
    class UndoRedoCommand {
        private isDisposed;
        private document;
        constructor(doc: U1.UDocument);
        Document: U1.UDocument;
        Undo(): void;
        Redo(): void;
        Dispose(): void;
    }
    class ElementCommand extends UndoRedoCommand {
        private _oldData;
        private _curData;
        private _state;
        private _eid;
        private _type;
        constructor(element: U1.UElement);
        Undo(): void;
        Redo(): void;
        private Do(state, data);
    }
    class CommandGroup extends UndoRedoCommand {
        private _commands;
        constructor(doc: U1.UDocument);
        Add(cmd: UndoRedoCommand): void;
        Count: number;
        AddFront(command: UndoRedoCommand): void;
        Undo(): void;
        Redo(): void;
    }
    class Transaction {
        private isFilished;
        CommandGroup: CommandGroup;
        IsFinished: boolean;
    }
    class UHistoryManager {
        static MaxStackCount: number;
        private m_transactionStack;
        private m_undoStack;
        private m_redoStack;
        private document;
        PropertyChangedEvent: Event2<UHistoryManager, string>;
        constructor(doc: U1.UDocument);
        Document: U1.UDocument;
        /**
         * 변경된 데이터가 있는지 여부
        */
        private HasChangedData;
        ClearTransactionStack(): void;
        /**
        * 명령 추가, 다시실행 스택 모두 제거, 실행취소 스택의 맨위에 추가
        */
        private AddCommand(commands);
        /**
        * 실행취소 스택 비움
        */
        private RemoveRedoStack();
        /**
        * 트렌젝션 시작
        */
        BeginTransaction(): Transaction;
        /**
        * 트렌젝션 종료
        */
        EndTransaction(transaction: Transaction): void;
        /**
        * 실행취소
        */
        Undo(): void;
        /**
        * 다시실행
        */
        Redo(): void;
        /**
        * 실행취소스택 제거
        */
        ClearUndoStack(): void;
        /**
        * 변경내용 저장
        */
        private SaveChanges();
        /**
        * 실행취소 명령, 실행취소 스택의 꼭대기에 위치
        */
        private UndoCommand();
        /**
        * 다시실행 명령, 다시실행 스택의 꼭대기에 위치
        */
        private RedoCommand();
        /**
         * 명령그룹이 트랜젝션 명령그룹인 경우
         */
        private IsCurrentCommandTransaction();
        /**
         * 실행취소 가능한지 여부
         */
        CanUndo(): boolean;
        /**
         * 다시실행 가능한지 여부
         */
        CanRedo(): boolean;
        InvokePropertyChanged(prop: string): void;
    }
}
declare namespace U1 {
    class UDocument {
        file: string;
        private elementTable;
        private historyManager;
        private isLoading;
        private isUndoRedo;
        private _selection;
        constructor();
        IsLoading: boolean;
        IsUndoRedo: boolean;
        Elements: Array<UElement>;
        Selection: USelection;
        GetElement(id: number): UElement;
        AddElement<T extends UElement>(c: {
            new (): T;
        }): T;
        AddElementWithData<T extends UElement>(c: {
            new (): T;
        }, data?: any): T;
        ElementTable: U1.UElementTable;
        AcceptChanges(): void;
        Undo(): void;
        Redo(): void;
        BeginTransaction(): void;
        EndTransaction(): void;
        AbortTransaction(): void;
        Clear(): void;
        ClearUndoHistory(): void;
        BeginLoad(): void;
        EndLoad(): void;
        Load(xDoc: XMLDocument): void;
        static formatXml(xml: string): string;
        ToXmlString(): string;
        getXmlZipStringAsync(callback: (data: string) => void): void;
        ElementAdded: Event2<UDocument, UElement>;
        ElementRemoving: Event2<UDocument, UElement>;
        AfterUndoRedo: Event2<UDocument, boolean>;
        BeforeEndTransaction: Event1<UDocument>;
        AfterEndTransaction: Event1<UDocument>;
        AfterAbortTransaction: Event1<UDocument>;
        ElementChanged: Event3<UDocument, UElement, string>;
        BeforeClear: Event1<UDocument>;
        AfterClear: Event1<UDocument>;
        BeforeLoading: Event1<UDocument>;
        AfterLoaded: Event1<UDocument>;
        AfterChanged: Event1<UDocument>;
        InvokeElementAdded(element: U1.UElement): void;
        InvokeElementRemoving(element: U1.UElement): void;
        InvokeAfterUndoRedo(isUndo: boolean): void;
        InvokeBeforeEndTransaction(): void;
        InvokeAfterEndTransaction(): void;
        InvokeAfterAbortTransaction(): void;
        InvokeElementChanged(element: UElement, prop: string): void;
        InvokeBeforeClear(): void;
        InvokeAfterClear(): void;
        InvokeAfterChanged(): void;
    }
    class UEditor {
        PickPoint(): U1.Vector3;
    }
    class USelection {
        SelectionChanged: Event1<USelection>;
        private _selection;
        private _selectionFilter;
        private _document;
        constructor(doc: UDocument);
        InvokeSelectionChanged(): void;
        Count: number;
        SelectedElements: Array<UElement>;
        SelectionFilter: (element: UElement) => boolean;
        Contains(element: UElement): boolean;
        Add(element: UElement, clear: boolean): void;
        Remove(element: UElement): void;
        AddRange(elements: Array<UElement>, clear: boolean): void;
        Clear(): void;
        private UnSelect();
    }
}
declare namespace U1 {
    class UNode extends UElement {
        private parent;
        private name;
        private order;
        Parent: UNode;
        Name: string;
        Order: number;
        Children: Array<UNode>;
        GetChildren<T extends UNode>(type: {
            new (): T;
        }, name?: string): T[];
        GetChildrenByName<T extends UNode>(type: {
            new (): T;
        }, name: string): T[];
        Parameters: Array<UParameter>;
        GetParameter(name: string, traceParent?: boolean): UParameter;
        AddParameter(name: string): UParameter;
        protected SetBuiltinParameter(name: string, value: boolean | number | string | Vector2 | Vector3 | Vector4 | Color): UParameter;
        SetChild<T extends UNode>(ctor: {
            new (): T;
        }, name: string): T;
        private last_order;
        AddChild<T extends UNode>(ctr: {
            new (): T;
        }, name?: string): T;
        GetChild<T extends UNode>(ctor: {
            new (): T;
        }, name: string): T;
        OnGetFields(fieldSet: U1.FieldSet): void;
        CopyTo(parent: UNode): UNode;
        private CopyElementTo(parent, clones, id_map);
        Delete(): void;
    }
}
declare namespace U1 {
    class UParameter extends UNode {
        private owner;
        Owner: UNode;
        private isBuiltin;
        private xdata;
        private lstring;
        private resultstr;
        private _result;
        IsBuiltin: boolean;
        XData: string;
        LString: string;
        ResultStr: string;
        Result: UVariant;
        OnGetFields(fieldSet: U1.FieldSet): void;
        InvokePropertyChanged(prop: string): void;
        SetVector2(vect2: Vector2): this;
        SetVector3(vect3: Vector3): this;
        SetVector4(vect4: Vector4): this;
        SetColor(color: Color): this;
        SetNumber(value: number): this;
        SetBool(value: boolean): this;
        SetVector(value: number[]): this;
        SetString(value: string): this;
        GetVector2(): Vector2;
        GetVector3(): Vector3;
        GetColor(): Color;
        GetString(): string;
        GetNumber(): number;
        GetBool(): boolean;
    }
}
declare namespace U1.CGAL {
    enum BOUNDED_SIDES {
        ON_BOUNDED_SIDE = 0,
        ON_BOUNDARY = 1,
        ON_UNBOUNDED_SIDE = 2,
    }
    enum ORIENTED_SIDES {
        ON_NEGATIVE_SIDE = 0,
        ON_ORIENTED_BOUNDARY = 1,
        ON_POSITIVE_SIDE = 2,
    }
    class Util {
        static PRECISION: number;
        static DoInersect(polygon0: Vector2[], polygon1: Vector2[]): boolean;
        static DoInersectLoops(loopsA: Array<Vector2[]>, loopsB: Array<Vector2[]>): boolean;
        static Min(points: Vector2[]): Vector2;
        static Max(points: Vector2[]): Vector2;
        static IntersectSegmentSegment(s0: Vector2, s1: Vector2, t0: Vector2, t1: Vector2, result: {
            s: number;
            t: number;
        }): boolean;
        static IntersectSegmentPoint(s0: Vector2, s1: Vector2, p: Vector2, result: {
            s: number;
        }): boolean;
        static DistanceSquared(s0: Vector2, s1: Vector2, p: Vector2): number;
        static CollectPolygonWithHoles(loops: Array<Vector2[]>, isIntersection?: boolean): Array<PolygonWithHoles2>;
    }
    class Polygon2 {
        private m_points;
        private static tmp_v0;
        private static tmp_v1;
        private static tmp_v2;
        private static tmp_v3;
        constructor(arg?: Polygon2 | Vector2[]);
        Count: number;
        Add(pt: Vector2): void;
        AddRange(collection: Array<Vector2>): void;
        Area(): number;
        Length(): number;
        Clear(): void;
        HasOnNegativeSide(pt: Vector2): boolean;
        HasOnPositiveSide(pt: Vector2): boolean;
        static DoIntersect(A: Polygon2, B: Polygon2): boolean;
        BoundedSide(pt: Vector2): BOUNDED_SIDES;
        OrientedSide(pt: Vector2): ORIENTED_SIDES;
        HasOnBoundary(pt: Vector2): boolean;
        HasOnBoundedSide(pt: Vector2): boolean;
        HasOnUnboundedSide(pt: Vector2): boolean;
        IsCCW(): boolean;
        IsConvex(): boolean;
        IsCW(): boolean;
        IsEmpty(): boolean;
        IsSimple(): boolean;
        Reverse(): void;
        LeftVertex(): Vector2;
        RightVertex(): Vector2;
        TopVertex(): Vector2;
        BottomVertex(): Vector2;
        private LeftVertexIndex();
        private RightVertexIndex();
        private TopVertexIndex();
        private BottomVertexIndex();
        Points: Vector2[];
        DoIntersectEdge(pgon: Polygon2): boolean;
        DoIntersect(pgon: Polygon2): boolean;
        GetPolygonList(): Array<Vector2[]>;
        GetAllPolygons(): Array<Polygon2>;
        private GetNotIsectSegs(points);
        static GetArea(points: Vector2[]): number;
        MakeSimple(): void;
        static Reverse(m_points: Vector2[]): void;
    }
    class PolygonSet2 {
        PolygonsWithHoles: Array<PolygonWithHoles2>;
        constructor(param?: Polygon2);
        NumberOfPolygonsWithHoles: number;
        IsEmpty: boolean;
        HasOnNegativeSide(pt: Vector2): boolean;
        HasOnPositiveSide(pt: Vector2): boolean;
        Area(): number;
        Clear(): void;
        Insert(polygon: Polygon2 | PolygonWithHoles2): void;
        DoIntersect(pgon: Polygon2 | PolygonWithHoles2 | PolygonSet2): boolean;
        Intersection(pgons: Polygon2 | PolygonWithHoles2 | PolygonSet2): void;
        private DoIntersection(b);
        Join(polygons: Polygon2 | PolygonWithHoles2 | PolygonSet2): void;
        private DoJoin(b);
        Difference(polygons: Polygon2 | PolygonWithHoles2 | PolygonSet2): void;
        private DoDifference(b);
        IntersectLine(line: Line2): boolean;
        Slice(line: Line2, res: {
            left: PolygonSet2;
            right: PolygonSet2;
        }): boolean;
        GetPolygonList(): Array<Vector2[]>;
        GetAllPolygons(): Array<Polygon2>;
    }
    class PolygonWithHoles2 {
        private m_outerBoundary;
        private m_holes;
        constructor(param?: Polygon2);
        OuterBoundary: Polygon2;
        HasOnNegativeSide(pt: Vector2): boolean;
        HasOnPositiveSide(pt: Vector2): boolean;
        Area(): number;
        Holes: Polygon2[];
        HasHoles: boolean;
        IsUnbounded: boolean;
        Clear(): void;
        AddHole(pgn_hole: Polygon2): void;
        EraseHole(pgn_hole: Polygon2): void;
        PolygonsAll: Array<Polygon2>;
        DoIntersect(B: Polygon2 | PolygonWithHoles2): boolean;
        GetPolygonList(): Array<Vector2[]>;
        GetAllPolygons(): Array<Polygon2>;
    }
}
declare namespace U1.CGAL {
    class LoopFinder {
        private VLIST;
        private ELIST;
        private AddVtx(p);
        private GetVtx(p);
        private static res_p;
        private AddEdge(s, e);
        private GetVTXsOnSement(start, end);
        private InsertEdge(start, end);
        private Split(edge, p, newPoint);
        private GetCrossEdge(p);
        AddLoop(path: Array<Vector2>, isReverse: boolean): void;
        AddPath(path: Array<Vector2>, isReverse: boolean): void;
        AddLoops(loops: Array<Vector2[]>, isReverse: boolean): void;
        GetLoops(inward: boolean): Array<Vector2[]>;
    }
}
declare namespace U1.Geom {
    import Polygon2 = U1.CGAL.Polygon2;
    class Face implements IUValue {
        private static s_handle;
        Handle: number;
        static TesselaterFunc: (face: Face, vertics: Vector3[]) => number[];
        constructor(boundary?: number[]);
        Boundary: number[];
        Holes: number[][];
        State: FaceStates;
        Normal: Vector3;
        Orign: Vector3;
        BoundingBox: BoundingBox;
        IsFlat: boolean;
        IsCap: boolean;
        HasHoles: boolean;
        GetVertexIndices(indics: {
            [index: number]: number;
        }): void;
        Clone(vertex_offset?: number): Face;
        ReplaceIndics(indicsMap: {
            [index: number]: number;
        }): void;
        Update(vertics: Array<Vector3>, force?: boolean): void;
        Flip(): void;
        GetUV(u: Vector3, v: Vector3): void;
        static Project(p: Vector3, uaxis: Vector3, vaxis: Vector3): Vector2;
        static PlaneIntersection(polygon: number[], vertics: Array<Vector3>, plane: Plane): PlaneIntersectionTypeEnum;
        static GetCuttingEdges(polygon: Array<number>, vertics: Vector3[], plane: Plane, result: Array<number>): boolean;
        GetCuttingEdges(vertics: Vector3[], plane: Plane, result: Array<number>): boolean;
        GetPolygonWithHoles(vertics: Vector3[], vmap?: {
            [index: number]: number;
        }, v2map?: {
            [index: number]: number;
        }): U1.CGAL.PolygonWithHoles2;
        Tesselate(vertics: Vector3[]): Array<number>;
        static TestIntersectFast(aVertics: Vector3[], aFace: Face, bVertics: Vector3[], bFace: Face): boolean;
        static InsertIsectPoints(polygon: number[], vertics: Array<Vector3>, plane: Plane, add_point_func: (p: Vector3) => number, isect_points: Array<Vector3>, result: {
            new_polygon?: Array<number>;
            insert_indics?: Array<number>;
        }): boolean;
        Cut(vertics: Vector3[], plane: Plane, add_point_func: (p: Vector3) => number, fronts: Array<Face>, backs: Array<Face>): boolean;
        static CreateFaces(pwhs: Array<U1.CGAL.PolygonWithHoles2>, v2map: {
            [index: string]: number;
        }, ivmap: {
            [index: number]: Vector2;
        }, state: FaceStates): Array<Face>;
        /**
        폴리곤과 평면의 교차
        @cut_normal :절단면의 노멀
        @cut_right  :절단면의 우측 방향
        @res_locs   :cut_right상에서의 위치
        */
        static GetPlaneIntersectLocs(polygon: number[], vertics: Vector3[], planeNormal: Vector3, ray: Ray3, res_locs: Array<number>): void;
        GetPlaneIntersectLocs(vertics: Vector3[], planeNormal: Vector3, ray: Ray3, res_locs: Array<number>): void;
        GetIsConvex(vertics: Vector3[]): boolean;
        GetArbitraryInsidePoint(vertics: Vector3[]): Vector3;
        GetLMostBoundaryIndex(vertics: Vector3[]): number;
        GetRMostBoundaryIndex(vertics: Vector3[]): number;
        GetLMostPoint(vertics: Vector3[]): Vector3;
        GetRMostPoint(vertics: Vector3[]): Vector3;
        GetPointIndics(indics: {
            [index: number]: boolean;
        }): void;
        ConvertFromStr(value: string): void;
        ConvertToStr(): string;
        CopyFrom(other: IUValue): void;
        Equals(other: IUValue): boolean;
    }
    class FaceCutter {
        static SplitFace(face: Face, vertics: Array<Vector3>, plane: Plane, insert_points: Array<Vector3>, front_faces: Array<Face>, back_faces: Array<Face>): boolean;
        static IsFront(points: number[], vertics: Array<Vector3>, plane: Plane): boolean;
        static GetPolygon(b: number[], vertics: Array<Vector3>, normal: Vector3): U1.CGAL.Polygon2;
        static Contains(boundary: Polygon2, hole: number[], vertics: Array<Vector3>, normal: Vector3): boolean;
    }
}
declare namespace U1.Geom {
    var EPSILON: number;
    enum FaceStates {
        None = 0,
        Cutted = 2,
        Cap = 4,
        Flat = 8,
    }
    function EqualNumbers(a: number[], b: number[]): boolean;
    function EqualValues<T extends IUValue>(a: IUValue[], b: IUValue[]): boolean;
    enum ShellContainsEnums {
        Outside = 0,
        Inside = 1,
        OnSurface = 2,
    }
    class Shell implements IUValue {
        private _mesh;
        private _boundingBox;
        private _boudningBoxInvalid;
        private _interiorEdges;
        private _perimeterEdges;
        private _outlineEdges;
        static MaxCuttedCache: number;
        Vertics: Vector3[];
        VertexNormals: Vector3[];
        Colors: Color[];
        UVs: Vector2[];
        Faces: Face[];
        BoundingBox: BoundingBox;
        CheckInside(p: Vector3): ShellContainsEnums;
        Refresh(): void;
        UpdateBoundingBox(boundingBox: BoundingBox): void;
        protected UpdateEdges(): void;
        protected CalOutlineEdges(look: Vector3): number[];
        GetInteriorEdges(): number[];
        GetPerimeterEdges(): number[];
        GetOutlineEdges(look: Vector3): number[];
        IntersectsBoundingBoxPlane(plane: Plane): PlaneIntersectionTypeEnum;
        Intersects(plane: Plane): PlaneIntersectionTypeEnum;
        GetMesh(): MeshData;
        GetBack(plane: U1.Plane): Shell;
        GetFront(plane: U1.Plane): Shell;
        CutWithPlane(plane: Plane, capFront?: boolean, capBack?: boolean): {
            front?: Shell;
            back?: Shell;
        };
        ConvertFromStr(value: string): void;
        ConvertToStr(): string;
        CopyFrom(other: IUValue): any;
        Equals(other: IUValue): boolean;
        Clone(): IUValue;
        private GetAddPointFunc(last_?);
        /**
        * 현재 셀을 면으로 분할
        */
        CutWithShell(other: Shell): void;
        Merge(other: Shell): void;
        RemoveUnusedPoints(): void;
        GetSubShells(): Shell[];
        Flip(): void;
        /**
         차집합
        */
        static Difference(a: Shell, b: Shell): Shell[];
        /**
         교집합
        */
        static Intersection(a: Shell, b: Shell): Shell[];
        /**
         합집합
        */
        static Join(a: Shell, b: Shell): Shell[];
    }
    class ShellCutted extends Shell {
        CuttingPlan: U1.Plane;
        IsFrontSide: boolean;
        CappingFaces: Face[];
        constructor();
        GetCuttingEdges(): Array<number>;
        IsCapped(): boolean;
        Cap(): boolean;
        static CollectPolygonWithHoles(loops: Array<Vector2[]>): Array<U1.CGAL.PolygonWithHoles2>;
        static FindLoops(edges: Array<number>): Array<number[]>;
    }
}
declare var default_font_data: any;
declare namespace U1.Graphics {
    enum FontStyleEnum {
        Normal = 0,
        Italic = 1,
        Oblique = 2,
    }
    enum FontWeightEnum {
        Normal = 0,
        Black = 1,
        Bold = 2,
        DemiBold = 3,
        ExtraBlack = 4,
        ExtraBold = 5,
        ExtraLight = 6,
        Heavy = 7,
        Light = 8,
        Medium = 9,
        Regular = 10,
        SemiBold = 11,
        Thin = 12,
        UltraBlack = 13,
        UltraBold = 14,
        UltraLight = 15,
    }
    class MeshChar {
        private _faces;
        Width: number;
        Height: number;
        Outlines: Array<Vector2[]>;
        Faces: Array<Vector2>;
        private Tessellate();
        private static tMin;
        private static tMax;
        Read(data: number[]): void;
    }
    class MeshFont {
        FontFamilyName: string;
        Chars: {
            [index: number]: MeshChar;
        };
        GetChar(c: number): MeshChar;
        GetMesh(text: string, fontSize: number, width: number, height: number, isMultiline: boolean): Vector2[];
        GetOutlines(text: string, fontSize: number, width: number, height: number, isMultiline: boolean): Array<Vector2[]>;
        Read(charsData: any): void;
        private static _default;
        static Default: MeshFont;
    }
}
declare namespace U1.LibTess {
    enum WindingRule {
        EvenOdd = 0,
        NonZero = 1,
        Positive = 2,
        Negative = 3,
        AbsGeqTwo = 4,
    }
    enum ElementType {
        Polygons = 0,
        ConnectedPolygons = 1,
        BoundaryContours = 2,
    }
    enum ContourOrientation {
        Original = 0,
        Clockwise = 1,
        CounterClockwise = 2,
    }
    class PQHandle {
        static Invalid: number;
        _handle: number;
        constructor(handle?: number);
    }
    class Vec3 {
        static Zero: Vec3;
        constructor(X?: number, Y?: number, Z?: number);
        SetValues(x: number, y: number, z: number): void;
        CopyFrom(source: Vec3): void;
        X: number;
        Y: number;
        Z: number;
        static Sub(lhs: Vec3, rhs: Vec3, result: Vec3): void;
        static Neg(v: Vec3): void;
        static Dot(u: Vec3, v: Vec3): number;
        static Normalize(v: Vec3): void;
        static LongAxis(v: Vec3): number;
        toString(): string;
    }
    class Vertex {
        _prev: Vertex;
        _next: Vertex;
        _anEdge: Edge;
        _coords: Vec3;
        _s: number;
        _t: number;
        _pqHandle: PQHandle;
        _n: number;
        _data: any;
    }
    class Face {
        _prev: Face;
        _next: Face;
        _anEdge: Edge;
        _trail: Face;
        _n: number;
        _marked: boolean;
        _inside: boolean;
        VertsCount: number;
    }
    class EdgePair {
        _e: Edge;
        _eSym: Edge;
        static Create(): EdgePair;
    }
    class Edge {
        _pair: EdgePair;
        _next: Edge;
        _Sym: Edge;
        _Onext: Edge;
        _Lnext: Edge;
        _Org: Vertex;
        _Lface: Face;
        _activeRegion: ActiveRegion;
        _winding: number;
        _Rface: Face;
        _Dst: Vertex;
        _Oprev: Edge;
        _Lprev: Edge;
        _Dprev: Edge;
        _Rprev: Edge;
        _Dnext: Edge;
        _Rnext: Edge;
        static EnsureFirst(e: Edge): Edge;
    }
    class MeshUtils {
        static Undef: number;
        static MakeEdge(eNext: Edge): Edge;
        static Splice(a: Edge, b: Edge): void;
        static MakeVertex(vNew: Vertex, eOrig: Edge, vNext: Vertex): void;
        static MakeFace(fNew: Face, eOrig: Edge, fNext: Face): void;
        static KillEdge(eDel: Edge): void;
        static KillVertex(vDel: Vertex, newOrg: Vertex): void;
        static KillFace(fDel: Face, newLFace: Face): void;
    }
    class ContourVertex {
        Position: Vec3;
        Data: any;
        toString(): any;
    }
    class Node<TValue> {
        _key: TValue;
        _prev: Node<TValue>;
        _next: Node<TValue>;
        Key: TValue;
        Prev: Node<TValue>;
        Next: Node<TValue>;
    }
    class Dict<TValue> {
        _leq: (lhs: TValue, rhs: TValue) => boolean;
        _head: Node<TValue>;
        constructor(leq: (lhs: TValue, rhs: TValue) => boolean);
        Insert(key: TValue): Node<TValue>;
        InsertBefore(node: Node<TValue>, key: TValue): Node<TValue>;
        Find(key: TValue): Node<TValue>;
        Min(): Node<TValue>;
        Remove(node: Node<TValue>): void;
    }
    class HandleElem<TValue> {
        _key: TValue;
        _node: number;
    }
    class PriorityHeap<TValue> {
        _leq: (lhs: TValue, rhs: TValue) => boolean;
        private _nodes;
        private _handles;
        private _size;
        private _max;
        private _freeList;
        private _initialized;
        Empty: boolean;
        constructor(initialSize: number, leq: (lhs: TValue, rhs: TValue) => boolean);
        private FloatDown(curr);
        private FloatUp(curr);
        Init(): void;
        Insert(value: TValue): PQHandle;
        ExtractMin(): TValue;
        Minimum(): TValue;
        Remove(handle: PQHandle): void;
    }
    class StackItem {
        p: number;
        r: number;
        constructor(ap: number, ar: number);
    }
    class PriorityQueue<TValue> {
        private _leq;
        private _heap;
        private _keys;
        private _order;
        private _size;
        private _max;
        private _initialized;
        Empty: boolean;
        constructor(initialSize: number, leq: (lhs: TValue, rhs: TValue) => boolean);
        static Swap(ab: {
            a: number;
            b: number;
        }): void;
        Init(): void;
        Insert(value: TValue): PQHandle;
        ExtractMin(): TValue;
        Minimum(): TValue;
        Remove(handle: PQHandle): void;
    }
    class Geom {
        static IsWindingInside(rule: WindingRule, n: number): boolean;
        static VertCCW(u: Vertex, v: Vertex, w: Vertex): boolean;
        static VertEq(lhs: Vertex, rhs: Vertex): boolean;
        static VertLeq(lhs: Vertex, rhs: Vertex): boolean;
        static EdgeEval(u: Vertex, v: Vertex, w: Vertex): number;
        static EdgeSign(u: Vertex, v: Vertex, w: Vertex): number;
        static TransLeq(lhs: Vertex, rhs: Vertex): boolean;
        static TransEval(u: Vertex, v: Vertex, w: Vertex): number;
        static TransSign(u: Vertex, v: Vertex, w: Vertex): number;
        static EdgeGoesLeft(e: Edge): boolean;
        static EdgeGoesRight(e: Edge): boolean;
        static VertL1dist(u: Vertex, v: Vertex): number;
        static AddWinding(eDst: Edge, eSrc: Edge): void;
        static Interpolate(a: number, x: number, b: number, y: number): number;
        static EdgeIntersect(o1: Vertex, d1: Vertex, o2: Vertex, d2: Vertex, v: Vertex): void;
    }
    class Mesh {
        _vHead: Vertex;
        _fHead: Face;
        _eHead: Edge;
        _eHeadSym: Edge;
        constructor();
        MakeEdge(): Edge;
        Splice(eOrg: Edge, eDst: Edge): void;
        Delete(eDel: Edge): void;
        AddEdgeVertex(eOrg: Edge): Edge;
        SplitEdge(eOrg: Edge): Edge;
        Connect(eOrg: Edge, eDst: Edge): Edge;
        ZapFace(fZap: Face): void;
        MergeConvexFaces(maxVertsPerFace: number): void;
        Check(): void;
    }
    class ActiveRegion {
        _eUp: Edge;
        _nodeUp: Node<ActiveRegion>;
        _windingNumber: number;
        _inside: boolean;
        _sentinel: boolean;
        _dirty: boolean;
        _fixUpperEdge: boolean;
    }
    class Tess {
        private _mesh;
        private _normal;
        private _sUnit;
        private _tUnit;
        private _bminX;
        private _bminY;
        private _bmaxX;
        private _bmaxY;
        private _windingRule;
        private _dict;
        private _pq;
        private _event;
        private _combineCallback;
        private _vertices;
        private _vertexCount;
        private _elements;
        private _elementCount;
        Normal: Vec3;
        SUnitX: number;
        SUnitY: number;
        SentinelCoord: number;
        Vertices: ContourVertex[];
        VertexCount: number;
        Elements: number[];
        ElementCount: number;
        constructor();
        private ComputeNormal(norm);
        private CheckOrientation();
        private ProjectPolygon();
        private TessellateMonoRegion(face);
        private TessellateInterior();
        private DiscardExterior();
        private SetWindingNumber(value, keepOnlyBoundary);
        private GetNeighbourFace(edge);
        private OutputPolymesh(elementType, polySize);
        private OutputContours();
        private SignedArea(vertices);
        AddContour(vertices: ContourVertex[], forceOrientation?: ContourOrientation): void;
        Tessellate(windingRule: WindingRule, elementType: ElementType, polySize: number, combineCallback: (position: Vec3, data: any[], weights: number[]) => any): void;
        private RegionBelow(reg);
        private RegionAbove(reg);
        private EdgeLeq();
        private DeleteRegion(reg);
        private FixUpperEdge(reg, newEdge);
        private TopLeftRegion(reg);
        private TopRightRegion(reg);
        private AddRegionBelow(regAbove, eNewUp);
        private ComputeWinding(reg);
        private FinishRegion(reg);
        private FinishLeftRegions(regFirst, regLast);
        private AddRightEdges(regUp, eFirst, eLast, eTopLeft, cleanUp);
        private SpliceMergeVertices(e1, e2);
        private VertexWeights(isect, org, dst, out);
        private GetIntersectData(isect, orgUp, dstUp, orgLo, dstLo);
        private CheckForRightSplice(regUp);
        private CheckForLeftSplice(regUp);
        private CheckForIntersect(regUp);
        private WalkDirtyRegions(regUp);
        private ConnectRightVertex(regUp, eBottomLeft);
        private ConnectLeftDegenerate(regUp, vEvent);
        private ConnectLeftVertex(vEvent);
        private SweepEvent(vEvent);
        private AddSentinel(smin, smax, t);
        private InitEdgeDict();
        private DoneEdgeDict();
        private RemoveDegenerateEdges();
        private InitPriorityQ();
        private DonePriorityQ();
        private RemoveDegenerateFaces();
        protected ComputeInterior(): void;
    }
}
declare namespace U1 {
    class Colors {
        static AliceBlue: Color;
        static AntiqueWhite: Color;
        static Aqua: Color;
        static Aquamarine: Color;
        static Azure: Color;
        static Beige: Color;
        static Bisque: Color;
        static Black: Color;
        static BlanchedAlmond: Color;
        static Blue: Color;
        static BlueViolet: Color;
        static Brown: Color;
        static BurlyWood: Color;
        static CadetBlue: Color;
        static Chartreuse: Color;
        static Chocolate: Color;
        static Coral: Color;
        static CornflowerBlue: Color;
        static Cornsilk: Color;
        static Crimson: Color;
        static Cyan: Color;
        static DarkBlue: Color;
        static DarkCyan: Color;
        static DarkGoldenrod: Color;
        static DarkGray: Color;
        static DarkGreen: Color;
        static DarkKhaki: Color;
        static DarkMagenta: Color;
        static DarkOliveGreen: Color;
        static DarkOrange: Color;
        static DarkOrchid: Color;
        static DarkRed: Color;
        static DarkSalmon: Color;
        static DarkSeaGreen: Color;
        static DarkSlateBlue: Color;
        static DarkSlateGray: Color;
        static DarkTurquoise: Color;
        static DarkViolet: Color;
        static DeepPink: Color;
        static DeepSkyBlue: Color;
        static DimGray: Color;
        static DodgerBlue: Color;
        static Firebrick: Color;
        static FloralWhite: Color;
        static ForestGreen: Color;
        static Fuchsia: Color;
        static Gainsboro: Color;
        static GhostWhite: Color;
        static Gold: Color;
        static Goldenrod: Color;
        static Gray: Color;
        static Green: Color;
        static GreenYellow: Color;
        static Honeydew: Color;
        static HotPink: Color;
        static IndianRed: Color;
        static Indigo: Color;
        static Ivory: Color;
        static Khaki: Color;
        static Lavender: Color;
        static LavenderBlush: Color;
        static LawnGreen: Color;
        static LemonChiffon: Color;
        static LightBlue: Color;
        static LightCoral: Color;
        static LightCyan: Color;
        static LightGoldenrodYellow: Color;
        static LightGray: Color;
        static LightGreen: Color;
        static LightPink: Color;
        static LightSalmon: Color;
        static LightSeaGreen: Color;
        static LightSkyBlue: Color;
        static LightSlateGray: Color;
        static LightSteelBlue: Color;
        static LightYellow: Color;
        static Lime: Color;
        static LimeGreen: Color;
        static Linen: Color;
        static Magenta: Color;
        static Maroon: Color;
        static MediumAquamarine: Color;
        static MediumBlue: Color;
        static MediumOrchid: Color;
        static MediumPurple: Color;
        static MediumSeaGreen: Color;
        static MediumSlateBlue: Color;
        static MediumSpringGreen: Color;
        static MediumTurquoise: Color;
        static MediumVioletRed: Color;
        static MidnightBlue: Color;
        static MintCream: Color;
        static MistyRose: Color;
        static Moccasin: Color;
        static NavajoWhite: Color;
        static Navy: Color;
        static OldLace: Color;
        static Olive: Color;
        static OliveDrab: Color;
        static Orange: Color;
        static OrangeRed: Color;
        static Orchid: Color;
        static PaleGoldenrod: Color;
        static PaleGreen: Color;
        static PaleTurquoise: Color;
        static PaleVioletRed: Color;
        static PapayaWhip: Color;
        static PeachPuff: Color;
        static Peru: Color;
        static Pink: Color;
        static Plum: Color;
        static PowderBlue: Color;
        static Purple: Color;
        static Red: Color;
        static RosyBrown: Color;
        static RoyalBlue: Color;
        static SaddleBrown: Color;
        static Salmon: Color;
        static SandyBrown: Color;
        static SeaGreen: Color;
        static SeaShell: Color;
        static Sienna: Color;
        static Silver: Color;
        static SkyBlue: Color;
        static SlateBlue: Color;
        static SlateGray: Color;
        static Snow: Color;
        static SpringGreen: Color;
        static SteelBlue: Color;
        static Tan: Color;
        static Teal: Color;
        static Thistle: Color;
        static Tomato: Color;
        static Transparent: Color;
        static Turquoise: Color;
        static Violet: Color;
        static Wheat: Color;
        static White: Color;
        static WhiteSmoke: Color;
        static Yellow: Color;
        static YellowGreen: Color;
    }
}
declare namespace U1 {
    enum CullModeEnum {
        NONE = 0,
        CW = 1,
        CCW = 2,
    }
    enum TextureAddressModeEnum {
        Wrap = 0,
        Clamp = 1,
        Mirror = 2,
    }
    enum SnapTypeEnum {
        None = 0,
        Point = 1,
        Edge = 2,
        MidEdge = 4,
        Face = 8,
        Grid = 16,
        Angle = 32,
    }
    enum SnapTargetEnum {
        None = 0,
        Curve = 1,
        Surface = 2,
        Grid = 4,
    }
    enum MappingTypeEnum {
        RealWorldSize = 0,
        SurfaceSize = 1,
    }
    class ISectInfo {
        private _isectPosition;
        private _iscetNormal;
        private _uv;
        Source: any;
        OriginalSource: any;
        Distance: number;
        Snap: SnapTypeEnum;
        FaceID: number;
        Attr: number;
        Vertices: Vector3[];
        UVs: Vector2[];
        IsectPosition: Vector3;
        IsectNormal: Vector3;
        UV: Vector2;
        Tag: any;
        Clone(): ISectInfo;
        CompareTo(other: ISectInfo): number;
        private static _cache;
        static New(): ISectInfo;
        static Release(v: ISectInfo): void;
        Release(): void;
    }
    interface SnapConfigListener {
        OnUseSnapChanged?: () => void;
        OnSnapChanged?: () => void;
        OnAngleSnapChanged?: () => void;
        OnGridSnapChanged?: () => void;
        OnDistSnapChanged?: () => void;
        OnSnapTargetChanged?: () => void;
    }
    class SnapConfig {
        private static s_listeners;
        static AddListener(listener: SnapConfigListener): void;
        static RemoveListener(listener: SnapConfigListener): void;
        static UseSnapChanged(): void;
        static SnapChanged(): void;
        static AngleSnapChanged(): void;
        static GridSnapChanged(): void;
        static DistSnapChanged(): void;
        static SnapTargetChanged(): void;
        private static m_snap;
        private static m_snapTarget;
        private static m_useSnap;
        private static m_angleSnap;
        private static m_gridSnap;
        private static m_distSnap;
        private static m_snapPixel;
        static UseSnap: boolean;
        static Snap: SnapTypeEnum;
        static SnapTarget: SnapTargetEnum;
        static GetSnap(snap: SnapTypeEnum): boolean;
        static GetSnapTarget(target: SnapTargetEnum): boolean;
        static SetSnap(snap: SnapTypeEnum, state: boolean): void;
        static SetSnapTarget(target: SnapTargetEnum, state: boolean): void;
        static AngelSnap: number;
        static GridSnap: number;
        static SnapPixel: number;
        static DistSnap: number;
        static WithinSnapPixel(mouse: Vector2, px: number, py: number): boolean;
        static GetSnapedDist(dist: number): void;
        static GetGridSnapedPoint(plane: Plane, point: Vector3): void;
        static GetGridSnapedPointGrid(grdOrign: Vector3, grdX: Vector3, grdY: Vector3, point: Vector3): void;
    }
    class MeshMaterial {
        constructor();
        Diffuse: Color;
        Ambient: Color;
        Emissive: Color;
        Specular: Color;
        SpecularPower: number;
        DiffuseTexture: string;
        Cull: CullModeEnum;
        Flag: number;
        Tag: number;
        TexOffset: Vector2;
        TexScale: Vector2;
        TexRotate: number;
        Opacity: number;
        AddressU: TextureAddressModeEnum;
        AddressV: TextureAddressModeEnum;
        AddressW: TextureAddressModeEnum;
        Pickable: boolean;
        AlwaysZWrite: boolean;
    }
    class GeomData {
        private _isBoundingInvalid;
        private _boundingBox;
        private _boundingSphere;
        BoundingBox: BoundingBox;
        BoundingSphere: BoundingSphere;
        UpdateBounding(boundingBox: BoundingBox, boundingSphere: BoundingSphere): void;
        MarkChanged(): void;
        IntersectTriangle(ray: Ray3): ISectInfo;
        GetSnapedPoint(mouse: Vector2, transform: Matrix4, camera: Camera): ISectInfo;
        IsInside(planes: Plane[], checkCross: boolean): boolean;
        IntersectW(ray: Ray3, worldM: Matrix4): ISectInfo;
        Intersect(ray: Ray3): ISectInfo;
    }
    class MeshData extends GeomData {
        private static tmp_v2_0;
        private static tmp_v2_1;
        private static tmp_v2_2;
        private static tmp_v2_3;
        private static tmp_v3_0;
        private static tmp_v3_1;
        private static tmp_v3_2;
        private static tmp_v3_3;
        Vertices: MeshVertex[];
        Indexes: number[];
        Attribute: number;
        UpdateBounding(boundingBox: BoundingBox, boundingSphere: BoundingSphere): void;
        VertexCount: number;
        IndexCount: number;
        FaceCount: number;
        Copy(): MeshData;
        Merge(mesh: MeshData, transform?: Matrix4): void;
        Transform(matrix: Matrix4): void;
        static IntersectTriangle(ray: Ray3, v0: MeshVertex, v1: MeshVertex, v2: MeshVertex, dirCheck?: boolean): ISectInfo;
        Intersect(ray: Ray3): ISectInfo;
        IntersectCount(ray: Ray3, result: {
            front: number;
            back: number;
            surface: number;
        }): void;
        IntersectW(wray: Ray3, worldM: Matrix4): ISectInfo;
        GetSnapedPoint(mouse: Vector2, worldM: Matrix4, camera: Camera): ISectInfo;
        /**
        면의 노멀이 바깥을 향함
        */
        IsInside(planes: Plane[], checkCross: boolean): boolean;
        SmoothNormal(): void;
        MakeFlatFaceMesh(): MeshData;
        private static s_box;
        static CreateRectangle(points: Vector3[]): MeshData;
        static CreateBox(): MeshData;
    }
    class MeshVertex {
        Position: Vector3;
        Normal: Vector3;
        UV: Vector2;
        constructor(pos?: Vector3, normal?: Vector3, uv?: Vector2);
        Clone(): MeshVertex;
        Transform(matrix: Matrix4): void;
    }
    class LineData extends GeomData {
        Points: LineVertex[];
        Indexes: number[];
        PointCount: number;
        IndexCount: number;
        SetColor(color: Color): void;
        UpdateBounding(boundingBox: BoundingBox, boundingSphere: BoundingSphere): void;
        IsInside(planes: Plane[], fCross: boolean): boolean;
        GetSnapedPoint(mouse: Vector2, transform: Matrix4, camera: Camera): ISectInfo;
    }
    class LineVertex {
        Position: Vector3;
        Color: Color;
        constructor(pos?: Vector3, color?: Color);
        Transform(matrix: Matrix4): void;
        Clone(): LineVertex;
    }
    class MeshUtil {
        private static tmp_v0;
        private static tmp_v1;
        private static tmp_v2;
        private static tmp_v3;
        private static tmp_v4;
        static Intersect_RayTriangle(ray: Ray3, v0: Vector3, v1: Vector3, v2: Vector3, dirCheck: boolean, res: {
            r: number;
            u: number;
            v: number;
        }): Vector3;
        /**
        면의 노멀이 바깥을 향함
        */
        static CheckEdgeCross(planes: Plane[], sv: Vector3, ev: Vector3): boolean;
    }
}
declare namespace U1.Triangulations {
    import Polygon2 = U1.CGAL.Polygon2;
    import PolygonSet2 = U1.CGAL.PolygonSet2;
    import PolygonWithHols = U1.CGAL.PolygonWithHoles2;
    class Vtx {
        P: Vector2;
        ID: number;
        Prev: Vtx;
        Next: Vtx;
        ELsit: Edge[];
        Left0: Vector2;
        Left1: Vector2;
        BiSect: Vector2;
        Index: number;
        private static tmp;
        Init(): void;
        IsBoundedSide(pt: Vector2): boolean;
        toString(): string;
    }
    class Edge {
        V0: Vtx;
        V1: Vtx;
        IsNew: boolean;
        Face0: Face;
        Face1: Face;
        IntersectSegment(p0: Vtx, p1: Vtx): boolean;
        private static tmp;
        IntersectLine(t0: Vector2, td: Vector2): number;
        toString(): string;
    }
    class Face {
        V0: Vtx;
        V1: Vtx;
        V2: Vtx;
        static tripoints: Vector2[];
        Area(): number;
        toString(): string;
    }
    class TDS {
        private VList;
        private EList;
        private FList;
        private v_id;
        static MIN_FACE_AREA: number;
        AddPolygon(polygon: Array<Vector2> | Polygon2): void;
        AddPolygonVtx(polygon: Array<Vtx>): void;
        private CalculateEdges();
        private CalculateFaces();
        private IsInside(p);
        GetMesh(): Mesh2;
    }
    class Face2 {
        V0: number;
        V1: number;
        V2: number;
        constructor(v0: number, v1: number, v2: number);
        toString(): string;
    }
    class Mesh2 {
        FList: Face2[];
        VList: Vector2[];
        Area(): number;
    }
    class PolygonTriangulation2 {
        private m_TDS;
        Fill(pgon: Vector2[] | Polygon2): void;
        FillPWH(pwh: PolygonWithHols): void;
        FillPSet(pgonSet: PolygonSet2): void;
        GetMesh(): Mesh2;
    }
}
declare namespace U1.UIControls {
    class DialogBase {
        protected _root: HTMLDivElement;
        protected _isInit: boolean;
        protected _isIniting: boolean;
        protected _isActive: boolean;
        protected binders: {
            [index: string]: IBiBase;
        };
        protected commands: {
            [index: string]: UCommand;
        };
        protected HtmlPage: string;
        AfterClosed: Event1<DialogBase>;
        Init(): void;
        protected InitBinders(): void;
        protected UnBinde(): void;
        protected UpdateBinders(): void;
        protected Accept(): void;
        ShowDialog(): void;
        protected OnClose(ev: JQueryEventObject): void;
        protected OnLoaded(): void;
    }
}
declare namespace U1.UIControls {
    class PanelBase implements INotifyPropertyChanged {
        protected _root: HTMLDivElement;
        protected _isInit: boolean;
        protected _isIniting: boolean;
        protected _isActive: boolean;
        protected binders: {
            [index: string]: IBiBase;
        };
        protected HtmlPage: string;
        Init(): void;
        Root: HTMLDivElement;
        IsActive: boolean;
        protected InitBinders(): void;
        protected UpdateBinders(): void;
        PauseBinders(): void;
        ResumeBinders(): void;
        ClearBinders(): void;
        ClearChildren(parent: HTMLElement): void;
        PropertyChanged: PropertyChangedEvent;
        InvokePropertyChanged(prop: string): void;
    }
}
declare namespace System.Collections {
    abstract class IList {
        abstract Add(item: any): any;
    }
}
declare namespace U1.WinCad.GScripts {
    class GScriptFormula {
        private _gformula;
        constructor();
        Formula: string;
        ScriptEngine: GScriptEngine;
        TargetObject: any;
        TargetProperty: string;
        Result: number;
        Update(): void;
    }
}
declare namespace U1.WinCad.GScripts {
    class GFormula {
        private _result;
        private _formula;
        private _invalid;
        /**
        * 변수값을 가져오는 함수
        */
        GetValue: (prop: string) => number;
        Result: number;
        Formula: string;
        Invalidate(): void;
        Evaluate(): void;
        private ReadFunction(str, pos, token);
        /**
        * 수식계산
        */
        private EvalExpression(str, pos);
        /**
        *   곱셈, 나눗셈  계산
        */
        private EvalTerm(str, pos);
        /**
        * 부호, (), 숫자, $참조 계산
        */
        private EvalFactor(str, pos);
        private static IsDigit(str, index);
        private static IsLetterOrDigit(str, index);
        private static ReadNumber(str, pos);
        /**
        * 공백 무시
        */
        private static SkipWhiteSpace(str, pos);
        private static _functions;
    }
}
declare namespace U1.WinCad.GScripts {
    class GScriptCharIndex {
        Script: string;
        LineNumber: number;
        CharNumber: number;
        CharIndex: number;
        MoveNext(): string;
        MoveNStep(step: number): void;
        Current: string;
        HasNext: boolean;
        HasPrev: boolean;
        Next: string;
        HasNthNext(nth: number): boolean;
        NthNext(idx: number): string;
        IsEnd: boolean;
        Prev: string;
        /**
        * 공백을 건무시하고 공백의 다음 지점에 위치 시킨다.
        */
        SkipWhiteSpace(): string;
        Copy(): GScriptCharIndex;
        ThrowException(message: string): void;
        Alert(condition: boolean, message: string): void;
    }
}
declare namespace U1.WinCad.GScripts {
    class GScriptEngine {
        static Types: {
            [index: string]: any;
        };
        static RegisterType(name: string, ctr: {
            new (): any;
        }): void;
        _properties: {
            [index: string]: any;
        };
        CharIndex: GScriptCharIndex;
        BuiltinVariables: {
            [index: string]: Object;
        };
        GetVariable(varname: string): number;
        GetPropertyObject(objname: string): Object;
        SetPropertyObject(objname: string, value: any): void;
        Parse(script: string): void;
        ParseIdentityExp(): string;
        ParseSetPropExp(obj: any): boolean;
        ParseArguments(out: {
            args: any[];
        }): boolean;
        ParseStringExpression(out: {
            str: string;
        }): boolean;
        ParseFormulaExpression(out: {
            formula?: GScriptFormula;
        }): boolean;
        private HasType(objType);
        private GetType(objType);
        ParseNewExpression(out: {
            newObject: any;
        }): boolean;
        ParseCollection(collection: Array<any>): boolean;
    }
}
declare namespace System.Windows.Media {
    class SolidColorBrush {
        Color: U1.Color;
        constructor(color?: U1.Color);
        static AliceBlue: SolidColorBrush;
        static AntiqueWhite: SolidColorBrush;
        static Aqua: SolidColorBrush;
        static Aquamarine: SolidColorBrush;
        static Azure: SolidColorBrush;
        static Beige: SolidColorBrush;
        static Bisque: SolidColorBrush;
        static Black: SolidColorBrush;
        static BlanchedAlmond: SolidColorBrush;
        static Blue: SolidColorBrush;
        static BlueViolet: SolidColorBrush;
        static Brown: SolidColorBrush;
        static BurlyWood: SolidColorBrush;
        static CadetBlue: SolidColorBrush;
        static Chartreuse: SolidColorBrush;
        static Chocolate: SolidColorBrush;
        static Coral: SolidColorBrush;
        static CornflowerBlue: SolidColorBrush;
        static Cornsilk: SolidColorBrush;
        static Crimson: SolidColorBrush;
        static Cyan: SolidColorBrush;
        static DarkBlue: SolidColorBrush;
        static DarkCyan: SolidColorBrush;
        static DarkGoldenrod: SolidColorBrush;
        static DarkGray: SolidColorBrush;
        static DarkGreen: SolidColorBrush;
        static DarkKhaki: SolidColorBrush;
        static DarkMagenta: SolidColorBrush;
        static DarkOliveGreen: SolidColorBrush;
        static DarkOrange: SolidColorBrush;
        static DarkOrchid: SolidColorBrush;
        static DarkRed: SolidColorBrush;
        static DarkSalmon: SolidColorBrush;
        static DarkSeaGreen: SolidColorBrush;
        static DarkSlateBlue: SolidColorBrush;
        static DarkSlateGray: SolidColorBrush;
        static DarkTurquoise: SolidColorBrush;
        static DarkViolet: SolidColorBrush;
        static DeepPink: SolidColorBrush;
        static DeepSkyBlue: SolidColorBrush;
        static DimGray: SolidColorBrush;
        static DodgerBlue: SolidColorBrush;
        static Firebrick: SolidColorBrush;
        static FloralWhite: SolidColorBrush;
        static ForestGreen: SolidColorBrush;
        static Fuchsia: SolidColorBrush;
        static Gainsboro: SolidColorBrush;
        static GhostWhite: SolidColorBrush;
        static Gold: SolidColorBrush;
        static Goldenrod: SolidColorBrush;
        static Gray: SolidColorBrush;
        static Green: SolidColorBrush;
        static GreenYellow: SolidColorBrush;
        static Honeydew: SolidColorBrush;
        static HotPink: SolidColorBrush;
        static IndianRed: SolidColorBrush;
        static Indigo: SolidColorBrush;
        static Ivory: SolidColorBrush;
        static Khaki: SolidColorBrush;
        static Lavender: SolidColorBrush;
        static LavenderBlush: SolidColorBrush;
        static LawnGreen: SolidColorBrush;
        static LemonChiffon: SolidColorBrush;
        static LightBlue: SolidColorBrush;
        static LightCoral: SolidColorBrush;
        static LightCyan: SolidColorBrush;
        static LightGoldenrodYellow: SolidColorBrush;
        static LightGray: SolidColorBrush;
        static LightGreen: SolidColorBrush;
        static LightPink: SolidColorBrush;
        static LightSalmon: SolidColorBrush;
        static LightSeaGreen: SolidColorBrush;
        static LightSkyBlue: SolidColorBrush;
        static LightSlateGray: SolidColorBrush;
        static LightSteelBlue: SolidColorBrush;
        static LightYellow: SolidColorBrush;
        static Lime: SolidColorBrush;
        static LimeGreen: SolidColorBrush;
        static Linen: SolidColorBrush;
        static Magenta: SolidColorBrush;
        static Maroon: SolidColorBrush;
        static MediumAquamarine: SolidColorBrush;
        static MediumBlue: SolidColorBrush;
        static MediumOrchid: SolidColorBrush;
        static MediumPurple: SolidColorBrush;
        static MediumSeaGreen: SolidColorBrush;
        static MediumSlateBlue: SolidColorBrush;
        static MediumSpringGreen: SolidColorBrush;
        static MediumTurquoise: SolidColorBrush;
        static MediumVioletRed: SolidColorBrush;
        static MidnightBlue: SolidColorBrush;
        static MintCream: SolidColorBrush;
        static MistyRose: SolidColorBrush;
        static Moccasin: SolidColorBrush;
        static NavajoWhite: SolidColorBrush;
        static Navy: SolidColorBrush;
        static OldLace: SolidColorBrush;
        static Olive: SolidColorBrush;
        static OliveDrab: SolidColorBrush;
        static Orange: SolidColorBrush;
        static OrangeRed: SolidColorBrush;
        static Orchid: SolidColorBrush;
        static PaleGoldenrod: SolidColorBrush;
        static PaleGreen: SolidColorBrush;
        static PaleTurquoise: SolidColorBrush;
        static PaleVioletRed: SolidColorBrush;
        static PapayaWhip: SolidColorBrush;
        static PeachPuff: SolidColorBrush;
        static Peru: SolidColorBrush;
        static Pink: SolidColorBrush;
        static Plum: SolidColorBrush;
        static PowderBlue: SolidColorBrush;
        static Purple: SolidColorBrush;
        static Red: SolidColorBrush;
        static RosyBrown: SolidColorBrush;
        static RoyalBlue: SolidColorBrush;
        static SaddleBrown: SolidColorBrush;
        static Salmon: SolidColorBrush;
        static SandyBrown: SolidColorBrush;
        static SeaGreen: SolidColorBrush;
        static SeaShell: SolidColorBrush;
        static Sienna: SolidColorBrush;
        static Silver: SolidColorBrush;
        static SkyBlue: SolidColorBrush;
        static SlateBlue: SolidColorBrush;
        static SlateGray: SolidColorBrush;
        static Snow: SolidColorBrush;
        static SpringGreen: SolidColorBrush;
        static SteelBlue: SolidColorBrush;
        static Tan: SolidColorBrush;
        static Teal: SolidColorBrush;
        static Thistle: SolidColorBrush;
        static Tomato: SolidColorBrush;
        static Transparent: SolidColorBrush;
        static Turquoise: SolidColorBrush;
        static Violet: SolidColorBrush;
        static Wheat: SolidColorBrush;
        static White: SolidColorBrush;
        static WhiteSmoke: SolidColorBrush;
        static Yellow: SolidColorBrush;
        static YellowGreen: SolidColorBrush;
        static SolidColorBrushFromUint(argb: number): SolidColorBrush;
    }
    class Transform {
        Matrix: U1.Matrix4;
    }
    class TransformCollection extends System.Collections.IList {
        private children;
        Add(item: Transform): void;
        Children: Array<Transform>;
    }
    class ScaleTransform extends Transform {
        CenterX: number;
        CenterY: number;
        ScaleX: number;
        ScaleY: number;
        Matrix: U1.Matrix4;
    }
    class RotateTransform extends Transform {
        Angle: number;
        CenterX: number;
        CenterY: number;
        Matrix: U1.Matrix4;
    }
    class TranslateTransform extends Transform {
        X: number;
        Y: number;
        Matrix: U1.Matrix4;
    }
    class TransformGroup extends Transform {
        Children: TransformCollection;
        Matrix: U1.Matrix4;
    }
    class PointCollection extends System.Collections.IList {
        private children;
        Add(item: Point): void;
        Children: Array<Point>;
    }
    class DoubleCollection extends System.Collections.IList {
        private children;
        Add(item: number): void;
        Children: Array<number>;
    }
}
declare namespace System.Windows {
    class UIElement {
        Render(parentEntity: U1.Views.ScEntity): void;
        RenderTransform: Media.Transform;
    }
    class FrameworkElement extends UIElement {
        Height: number;
        Width: number;
    }
    class Point {
        X: number;
        Y: number;
        constructor(x?: number, y?: number);
    }
    /**
    *     자식 요소가 부모의 레이아웃 슬롯 내에 세로 방향으로 배치되거나 늘어나는 방식을 설명합니다.
    */
    enum VerticalAlignment {
        /**
        * 요소를 부모 레이아웃 슬롯의 위쪽에 맞춥니다.
        */
        Top = 0,
        /**
        *     요소를 부모 레이아웃 슬롯의 가운데에 맞춥니다.
        */
        Center = 1,
        /**
        *     요소를 부모 레이아웃 슬롯의 아래쪽에 맞춥니다.
        */
        Bottom = 2,
        /**
        *     요소를 늘여 부모 요소의 전체 레이아웃 슬롯을 채웁니다.
        */
        Stretch = 3,
    }
}
declare namespace System.Windows.Shapes {
    /** 요약:
    *     System.Windows.Shapes.Ellipse, System.Windows.Shapes.Polygon 및 System.Windows.Shapes.Rectangle
    *     등의 도형 요소에 대해 기본 클래스를 제공합니다.
    */
    abstract class Shape extends FrameworkElement {
        Fill: Media.SolidColorBrush;
        Stroke: Media.SolidColorBrush;
        StrokeThickness: number;
        StrokeDashArray: Media.DoubleCollection;
        protected SetStyle(entity: U1.Views.ScEntity): void;
    }
    class Rectangle extends Shape {
        RadiusX: number;
        RadiusY: number;
        Render(parentEntity: U1.Views.ScEntity): void;
    }
    class RectanglePattern extends Shape {
        IsHorzontal: boolean;
        StartMargin: number;
        Span: number;
        Render(parentEntity: U1.Views.ScEntity): void;
    }
    class Polygon extends Shape {
        Points: Media.PointCollection;
        Render(parentEntity: U1.Views.ScEntity): void;
    }
    class Polyline extends Shape {
        Points: Media.PointCollection;
        Render(parentEntity: U1.Views.ScEntity): void;
    }
    class Line extends Shape {
        X1: number;
        X2: number;
        Y1: number;
        Y2: number;
        Render(parentEntity: U1.Views.ScEntity): void;
    }
    class Ellipse extends Shape {
        Render(parentEntity: U1.Views.ScEntity): void;
    }
}
declare namespace System.Windows.Controls {
    class Panel extends FrameworkElement {
        Background: Media.SolidColorBrush;
        Children: UIElementCollection;
        Render(parentEntity: U1.Views.ScEntity): void;
    }
    class Canvas extends Panel {
        constructor();
    }
    class UIElementCollection extends Collections.IList {
        Children: UIElement[];
        Add(item: any): void;
    }
}
declare namespace U1.Views {
    class ControlComponent {
        private _activeControl;
        private _orderedItems;
        private _view;
        constructor(scene: ViewBase);
        View: ViewBase;
        ActiveControl: VControl;
        Controls: Array<VControl>;
        OrderedControls: Array<VControl>;
        AddControl<T extends VControl>(ctor: {
            new (comp: ControlComponent): T;
        }): T;
        RemoveControl(item: VControl): void;
        private _controlAdded;
        private _controlRemoving;
        ControlAdded: Event2<ControlComponent, VControl>;
        ControlRemoving: Event2<ControlComponent, VControl>;
        InvokeControlAdded(entity: VControl): void;
        InvokeControlRemoving(item: VControl): void;
        Pick(isectContext: ISectContext): {
            ISect: ISectInfo;
            Control: VControl;
        };
        Update(): void;
    }
    class VControl {
        private _comp;
        private _isDisposed;
        protected _ver: number;
        protected _updatever: number;
        protected _transform: Matrix4;
        Tag: any;
        Tag1: any;
        constructor(comp: ControlComponent);
        IsPickable: boolean;
        Order: number;
        Component: ControlComponent;
        IsDisposed: boolean;
        View: ViewBase;
        Scene: SceneBase;
        Transform: Matrix4;
        protected MarkChanged(): void;
        CheckIntersect(isectContext: ISectContext): U1.ISectInfo;
        Update(): void;
        protected OnUpdate(): void;
        Dispose(): void;
        Clear(): void;
        OnMouseEnter(): void;
        OnMouseLeave(): void;
        OnMouseMove(ev: MouseEvent): boolean;
        OnMouseUp(ev: MouseEvent): boolean;
        OnMouseDown(ev: MouseEvent): boolean;
        OnMouseWheel(ev: MouseWheelEvent): boolean;
        OnPress(ev: HammerInput): boolean;
        OnPanMove(ev: HammerInput): boolean;
        OnPanStart(ev: HammerInput): boolean;
        OnPanEnd(ev: HammerInput): boolean;
        OnPinch(ev: HammerInput): boolean;
        OnTouchStart(ev: TouchEvent): boolean;
        OnTouchMove(ev: TouchEvent): boolean;
        OnTouchEnd(ev: TouchEvent): boolean;
        AfterMouseDown: Event2<VControl, MouseEvent>;
        AfterMouseUp: Event2<VControl, MouseEvent>;
    }
    class VcDimension extends VControl {
        private static OFFSET_TOP;
        private static ARROW_LEN;
        private _text;
        private _start;
        private _end;
        private _normal;
        private _fontSize;
        private _offset;
        private _textOffset;
        private _textAlign;
        constructor(comp: ControlComponent);
        Text: string;
        Start: Vector3;
        End: Vector3;
        Normal: Vector3;
        FontSize: number;
        /**
        * 중심선을 오른쪽으로 이동
        */
        Offset: number;
        TextOffset: Vector2;
        private wstart;
        private wend;
        private wnorm;
        private wleft;
        /**
        * 왼쪽 방향
        */
        Left: Vector3;
        TextAlign: System.Windows.VerticalAlignment;
        /**
        * 텍스트 위치
        */
        TextLocation: Vector3;
        protected UpdateBounding(): void;
        IsTextEditing: boolean;
        private _line;
        private _startArrow;
        private _endArrow;
        private _startBar;
        private _endBar;
        private _scText;
        private _board;
        Clear(): void;
        protected OnUpdate(): void;
        TextLocationWorld: Vector3;
        private _textXForm;
        private DrawLine();
        ReadOnly: boolean;
        private isEditing;
        BeginEdit(): void;
        OnMouseDown(ev: MouseEvent): boolean;
        private RemoveInput();
        CancelEdit(): void;
        EndEdit(): void;
        AfterEndEdit: Event2<VcDimension, string>;
        AfterCancelEdit: Event1<VcDimension>;
    }
}
declare namespace U1.Views {
    class ScEntity {
        private static _handle;
        protected _transform: Matrix4;
        protected _worldTransform: Matrix4;
        protected _boundingBox: BoundingBox;
        protected _boundingSphere: BoundingSphere;
        protected _geometryBBx: BoundingBox;
        protected _worldBoundingSphere: BoundingSphere;
        protected _isInvalidBounding: boolean;
        protected _isInvalidWorldBounding: boolean;
        protected _parent: ScEntity;
        protected _children: Array<ScEntity>;
        protected _orderedChildren: Array<ScEntity>;
        protected _strokeStr: string;
        protected _fillStr: string;
        protected _stroke: Color;
        protected _strokeDash: number[];
        protected _fill: Color;
        protected _alpha: number;
        protected _strokeThickness: number;
        protected _order: number;
        protected _invalidOrder: boolean;
        protected _presenter: UElementPresenter;
        protected _control: VControl;
        Ver: number;
        protected UpdateVer: number;
        IsPickable: boolean;
        Handle: number;
        IsInvalid: boolean;
        Presenter: UElementPresenter;
        Control: VControl;
        Tag: any;
        constructor();
        Stroke: Color;
        StrokeStr: string;
        Fill: Color;
        FillStr: string;
        Filled: boolean;
        /**
        * 불투명 정도 0~1.0
        */
        Alpha: number;
        StrokeThickness: number;
        StrokeDash: number[];
        Parent: ScEntity;
        Order: number;
        Visible: boolean;
        Transform: Matrix4;
        WorldTransform: Matrix4;
        BoundingBox: BoundingBox;
        BoundingSphere: BoundingSphere;
        WorldBoundingSphere: BoundingSphere;
        Component: EntityComponent;
        Children: Array<ScEntity>;
        OrderedChildren: Array<ScEntity>;
        AddChild(entity: ScEntity): ScEntity;
        RemoveChild(entity: ScEntity): void;
        Delete(): void;
        SetChanged(): void;
        protected UpdateBounding(): void;
        protected UpdateGeometryBounding(): void;
        protected OnDeleting(): void;
        CheckIntersect(isectContext: ISectContext): U1.ISectInfo;
        protected OnCheckIntersect(isectContext: ISectContext): U1.ISectInfo;
        IsInside(planes: Plane[], wm: Matrix4, checkCross: boolean): boolean;
        Invalidate(): void;
        InvalidateBounding(): void;
        InvalidateOrderedChildren(): void;
        protected static tmp_m0: Matrix4;
        protected static tmp_m1: Matrix4;
        protected static tmp_m2: Matrix4;
        protected static tmp_m3: Matrix4;
        protected static tmp_v30: Vector3;
        protected static tmp_v31: Vector3;
        protected static tmp_v32: Vector3;
        protected static tmp_v33: Vector3;
        protected static tmp_v34: Vector3;
        protected static tmp_bx0: BoundingBox;
        protected static tmp_bx1: BoundingBox;
        protected static tmp_bx2: BoundingBox;
        protected static tmp_r30: Ray3;
        protected static tmp_r31: Ray3;
        protected static tmp_sphere_1: BoundingSphere;
        Update(context: UpdateContext): void;
        protected OnUpdate(context: UpdateContext): void;
        Draw(context: DrawContext): void;
        protected OnDraw(context: DrawContext): void;
        protected InvalidateWorldTransform(): void;
    }
    class ScPoint extends ScEntity {
        private static _side;
        private _position;
        private _radius;
        private _points;
        private _triangles;
        constructor();
        Filled: boolean;
        Position: Vector3;
        Radius: number;
        Points: Vector3[];
        Triangles: Vector3[];
        protected OnCheckIntersect(context: ISectContext): U1.ISectInfo;
        Invalidate(): void;
        static GetNearestPoint(ray: Ray3, point: U1.Vector3, min_dist: number): Vector3;
    }
    class ScPolyLine extends ScEntity {
        private _points;
        private _triangles;
        Points: Vector3[];
        Triangles: Vector3[];
        constructor();
        protected UpdateGeometryBounding(): void;
        SetChanged(): void;
        protected OnCheckIntersect(context: ISectContext): U1.ISectInfo;
        private static tmp_st;
        static GetNearestPoint(ray: Ray3, points: U1.Vector3[], isClosed: boolean, min_dist: number, result_ptRay: Vector3, result_ptPath: Vector3): void;
        static Tesselate(points: U1.Vector3[]): Vector3[];
        static CheckPolygonInside(ray: Ray3, point: Vector3, points: U1.Vector3[]): boolean;
    }
    class ScPolygon extends ScPolyLine {
        constructor();
        protected OnCheckIntersect(context: ISectContext): U1.ISectInfo;
    }
    class ScText extends ScEntity {
        private _text;
        private _fontSize;
        private _height;
        private _width;
        private _actualWidth;
        private _background;
        private _backgroundStr;
        private _lines;
        private _max_line_index;
        static MeasureTextureWidthFunc: (text: string, fontsize: number) => number;
        constructor();
        Background: Color;
        BackgroundStr: string;
        Text: string;
        Lines: string[];
        Width: number;
        Height: number;
        ActualWidth: number;
        IsSingeLine: boolean;
        FontSize: number;
        SetChanged(): void;
        protected UpdateGeometryBounding(): void;
        protected OnCheckIntersect(context: ISectContext): U1.ISectInfo;
    }
    class ScMesh extends ScEntity {
        private _meshData;
        MeshData: MeshData;
        Material: ScMaterial;
        constructor();
        protected UpdateGeometryBounding(): void;
    }
    class ScGroup extends ScEntity {
    }
    class ScEllipse extends ScEntity {
        private static _ellipse_side;
        private _position;
        private _width;
        private _height;
        private _points;
        private _triangles;
        Position: Vector3;
        Width: number;
        Height: number;
        Points: Vector3[];
        Triangles: Vector3[];
        protected UpdateGeometryBounding(): void;
        Invalidate(): void;
        CheckIntersect(context: ISectContext): U1.ISectInfo;
    }
    class EntityComponent extends ScEntity {
        private _scene;
        constructor(scene: SceneBase);
        Scene: SceneBase;
        Invalidate(): void;
        Pick(isectContext: ISectContext): PickResult;
        SelectRegion(lt: Vector2, rb: Vector2, allowCross?: boolean): ScEntity[];
        Clear(): void;
    }
    class WorldComponent extends EntityComponent {
        constructor(scene: SceneBase);
    }
    class OverlayComponent extends EntityComponent {
        constructor(scene: SceneBase);
    }
    class ScreenComponent extends EntityComponent {
        constructor(scene: SceneBase);
    }
}
declare namespace U1.Views {
    class UDocumentPresenter {
        private document;
        private view;
        private _elementPresenters;
        private m_selection;
        private m_selectionBoxDirty;
        static Creaters: {
            [index: string]: {
                new (): U1.Views.UElementPresenter;
            };
        };
        static Register<E extends UElement, P extends UElementPresenter>(ecreater: {
            new (): U1.UElement;
        }, pcreate: {
            new (): U1.Views.UElementPresenter;
        }): void;
        constructor();
        Document: UDocument;
        View: ViewBase;
        Selection: Array<UElementPresenter>;
        protected ElementPresenters: {
            [index: number]: UElementPresenter;
        };
        Update(): void;
        InvalidateAll(): void;
        protected OnElementAdded(doc_: UDocument, elm_: UElement): void;
        protected OnElementRemoving(doc_: UDocument, elm_: UElement): void;
        protected OnElementPropertyChanged(doc_: UDocument, elem: UElement, prop: string): void;
        protected OnSelectionChanged(selectin: USelection): void;
        protected OnAfterUndoRedo(doc: UDocument, isUndo: boolean): void;
        protected OnAfterLoaded(doc: UDocument): void;
        protected OnAfterClear(doc: UDocument): void;
        protected OnAfterAbortTransaction(doc: UDocument): void;
        protected OnAfterEndTransaction(doc: UDocument): void;
        protected xform2: VcXForm2;
        protected OnAttach(elm: UElement): void;
        protected CreatePresenter(elm_: UElement): UElementPresenter;
        protected Clear(): void;
        GetPresenter<T extends UElementPresenter>(ctr: {
            new (): T;
        }, elm: UElement): T;
        ShowSelectionBox(): void;
    }
    class UElementPresenter {
        static SelectStrokeColor: Color;
        static SelectFillColor: Color;
        protected _element: UElement;
        Invalid: boolean;
        protected _isDisposed: boolean;
        protected _isSelected: boolean;
        Element: UElement;
        IsSelected: boolean;
        protected OnSelected(): void;
        protected OnDeselected(): void;
        DocumentPresesnter: UDocumentPresenter;
        View: ViewBase;
        Scene: SceneBase;
        IsDisposed: boolean;
        Update(): void;
        protected OnUpdate(): void;
        protected OnClear(): void;
        Dispose(): void;
        OnElementPropertyChanged(sender: UElement, prop: string): void;
        AddTransform(matrix: Matrix4): void;
        CanMove(): boolean;
        BeginMove(): void;
        EndMove(from: Vector2, to: Vector2): void;
        Move(from: Vector2, to: Vector2): void;
        CancelMove(): void;
    }
}
declare namespace U1.Views {
    class SceneBase {
        private _camera;
        private _view;
        Light1: U1.Light;
        Light2: U1.Light;
        Light3: U1.Light;
        constructor(view: ViewBase);
        View: ViewBase;
        Camera: ScCamera;
        World: WorldComponent;
        Overlay: OverlayComponent;
        Screen: ScreenComponent;
        Textures: TextureComponent;
        Materials: MaterialComponent;
        Update(): void;
        Draw(): void;
        Clear(): void;
        protected CreateDrawContext(): DrawContext;
        protected CreateUpdateContext(): UpdateContext;
        protected OnBeginUpdate(): void;
        protected OnEndUpdate(): void;
        protected OnBeginDraw(context: DrawContext): void;
        protected OnEndDraw(context: DrawContext): void;
        newPoint(): ScPoint;
        newPolyLine(): ScPolyLine;
        newPolygon(): ScPolygon;
        newText(): ScText;
        newMesh(): ScMesh;
        newGroup(): ScGroup;
        newEllipse(): ScEllipse;
        MeasureTextureWidth(text: string, fontsize: number): number;
    }
    class ScCamera {
        private position;
        private lookat;
        private up;
        private fov;
        private near;
        private far;
        private orthoheight;
        private projectionmode;
        private viewport;
        ver: number;
        private ViewProj;
        private vpVer;
        GetPosition(result?: Vector3): Vector3;
        Position: Vector3;
        GetLookAt(result?: Vector3): Vector3;
        LookAt: Vector3;
        GetUp(result?: Vector3): Vector3;
        Up: Vector3;
        /**
        * radian
        */
        FOV: number;
        Near: number;
        Far: number;
        OrthoHeight: number;
        ProjectionMode: ProjectionTypeEnum;
        ViewportWidth: number;
        ViewportHeight: number;
        ViewportX: number;
        ViewportY: number;
        constructor();
        GetFrustum(result?: BoundingFrustum): BoundingFrustum;
        GetRight(result?: Vector3): Vector3;
        GetDirection(result: Vector3): Vector3;
        Aspect: number;
        GetViewMatrix(result?: Matrix4): Matrix4;
        GetProjMatrix(result?: Matrix4): Matrix4;
        static Default: ScCamera;
        CalPickingRay(x: number, y: number, result?: Ray3): Ray3;
        WorldToScreen(wp: Vector3, result?: Vector3): Vector3;
        ScreenToWorld(sp: Vector3, result?: Vector3): Vector3;
        GetRotation(targetCamera: ScCamera): {
            axis: Vector3;
            angle: number;
            roll: number;
        };
        static GetRotation(src: Matrix4, target: Matrix4): {
            axis: Vector3;
            angle: number;
            roll: number;
        };
        Roll(roll: number): void;
        Rotate(pos: Vector3, axis: Vector3, ang: number): void;
        ScreenToPlane(pt: Vector2, plane: Plane, result?: Vector3): Vector3;
        Move(offset: Vector3): void;
        Clone(): ScCamera;
        private static tmp_v0;
        private static tmp_v1;
        private static tmp_v2;
        private static tmp_m0;
        private static tmp_m1;
        private static tmp_m2;
        private static tmp_r0;
    }
    class ScResource {
        Name: string;
    }
    class ScTexture extends ScResource {
        Uri: string;
    }
    class ScMaterial extends ScResource {
        Diffuse: Color;
        Ambient: Color;
        Texture: ScTexture;
    }
}
declare namespace U1.Views {
    class ViewBase {
        private _board;
        private document;
        private documentPresenter;
        private _workingPlane;
        private _controlComponent;
        private _scene;
        private _needZoomFit;
        private _afterUpdated;
        IsInvalid: boolean;
        constructor();
        Document: UDocument;
        DocumentPresenter: UDocumentPresenter;
        Controls: ControlComponent;
        Scene: SceneBase;
        Width: number;
        Height: number;
        Board: HTMLElement;
        WorkingPlane: Plane;
        ActiveControl: VControl;
        private _timerToken;
        Activate(): void;
        DeActive(): void;
        Invalidate(): void;
        Update(): void;
        protected OnBeginUpdate(): void;
        protected OnEndUpeate(): void;
        ZoomFit(): void;
        ZoomView(focus: Vector2, delt: number): void;
        ScaleView(focus: Vector2, scale: number): void;
        PanPlane(plane: Plane, sp0: Vector2, sp1: Vector2): void;
        GetClippingCorners(p1: Vector2, p2: Vector2): Vector3[];
        GetRay(screen: Vector2, result?: Ray3): Ray3;
        private picking_ray;
        Pick(screen_pos: Vector2): PickResult;
        SelectRegion(lt: Vector2, rb: Vector2, allowCross?: boolean): ScEntity[];
        private _defaultTool;
        private _activeTool;
        DefaultTool: VcTool;
        ActiveTool: VcTool;
        private static tmp_v20;
        private static tmp_v21;
        private static tmp_v22;
        private static tmp_v23;
        private static tmp_v30;
        private static tmp_v31;
        private static tmp_v32;
        private static tmp_v33;
        AfterUpdated: Event1<ViewBase>;
        protected _hammer: HammerManager;
        protected _pan_pos: Vector2;
        protected _prev_scale: number;
        CurMv: Vector2;
        CurDn: Vector2;
        CurUp: Vector2;
        OldMv: Vector2;
        OldDn: Vector2;
        OldUp: Vector2;
        protected AttachUIEventHandlers(board: HTMLElement): void;
        protected DetachUIEventHandlers(board: HTMLElement): void;
        protected AttachGestures(board: HTMLElement): void;
        protected DetachGestures(board: HTMLElement): void;
        protected _onTouchStart: (ev: TouchEvent) => void;
        protected _onTouchMove: (ev: TouchEvent) => boolean;
        protected _onTouchEnd: (ev: TouchEvent) => boolean;
        protected _onMouseMove: (ev: MouseEvent) => void;
        protected _onMouseUp: (ev: MouseEvent) => void;
        protected _onMouseDown: (ev: MouseEvent) => void;
        protected _onMouseWheel: (ev: MouseWheelEvent) => void;
        protected _onPress: (ev: HammerInput) => void;
        protected _onPanMove: (ev: HammerInput) => boolean;
        protected _onPanStart: (ev: HammerInput) => void;
        protected _onPanEnd: (ev: HammerInput) => boolean;
        protected _onPinch: (ev: HammerInput) => boolean;
        protected _isMouseDown: boolean;
        IsMouseDown: boolean;
        protected OnMouseMove(ev: MouseEvent): void;
        protected OnMouseUp(ev: MouseEvent): void;
        protected OnMouseDown(ev: MouseEvent): void;
        protected OnMouseWheel(ev: MouseWheelEvent): void;
        protected OnPress(ev: HammerInput): void;
        protected OnPanMove(ev: HammerInput): boolean;
        protected OnPanStart(ev: HammerInput): void;
        protected OnPanEnd(ev: HammerInput): boolean;
        protected OnPinch(ev: HammerInput): boolean;
        protected OnTouchStart(te: TouchEvent): void;
        protected OnTouchMove(ev: TouchEvent): boolean;
        protected OnTouchEnd(te: TouchEvent): boolean;
        protected OnSelectionChanged(sel: USelection): void;
        protected CreateScene(): SceneBase;
    }
    class Viewport {
        X: number;
        Y: number;
        Width: number;
        Height: number;
        MinDepth: number;
        MaxDepth: number;
        ConvertFromStr(value: string): void;
        ConvertToStr(): string;
        Equals(other: Viewport): boolean;
        constructor(x?: number, y?: number, w?: number, h?: number, min?: number, max?: number);
        Project(source: Vector3, projection: Matrix4, view: Matrix4, world: Matrix4): Vector3;
        ProjectRef(source: Vector3, projection: Matrix4, view: Matrix4, world: Matrix4, ref: Vector3): Vector3;
        ProjectM(source: Vector3, matrix: Matrix4): Vector3;
        ProjectMRef(source: Vector3, matrix: Matrix4, ref: Vector3): Vector3;
        Unproject(source: Vector3, projection: Matrix4, view: Matrix4, world: Matrix4): Vector3;
        UnprojectRef(source: Vector3, projection: Matrix4, view: Matrix4, world: Matrix4, ref: Vector3): Vector3;
        AspectRatio: number;
        private static tmp_v30;
        private static tmp_v31;
        private static tmp_v32;
        private static tmp_v33;
        private static tmp_m0;
        private static tmp_m1;
        private static tmp_m2;
        private static tmp_m3;
        private static tmp_m4;
    }
    class UpdateContext {
        IsScreenSpace: boolean;
    }
    class DrawContext {
        ViewMatrix: Matrix4;
        ProjMatrix: Matrix4;
        ViewProjMatrix: Matrix4;
        Scene: SceneBase;
        IsScreenSpace: boolean;
        IsOveraySpace: boolean;
        WorldToScreen: (wpos: Vector3, result?: Vector3) => Vector3;
    }
    class ISectContext {
        View: Vector2;
        Ray: Ray3;
        MaxDistance: number;
        PickingOsnapTarget: boolean;
        WorldToScreen: (wpos: Vector3, result?: Vector3) => Vector3;
        ScreenWithinSq: number;
        ISect: ISectInfo;
        IsScreenSpace: boolean;
        IsOveraySpace: boolean;
        constructor(view: Vector2, ray: Ray3, maxDistance: number);
        IsLineIsect(pOnRay: any, pOnObject: any, lineWidth?: number): boolean;
    }
    class PickResult {
        ISect: ISectInfo;
        Node: ScEntity;
        Control: VControl;
        constructor();
        private static _cache;
        static New(): PickResult;
        static Release(v: PickResult): void;
        Release(): void;
    }
    class TextureComponent {
        private _scene;
        constructor(scene: SceneBase);
        Scene: SceneBase;
        Textures: {
            [index: string]: ScTexture;
        };
        GetOrAddTexture<T extends ScTexture>(c: {
            new (): T;
        }, name: string): T;
        GetTexture<T extends ScTexture>(c: {
            new (): T;
        }, name: string): ScTexture;
        AddTexture<T extends ScTexture>(c: {
            new (): T;
        }, name: string): T;
        RemoveTexture(entity: ScTexture): void;
        Clear(): void;
    }
    class MaterialComponent {
        private _scene;
        constructor(scene: SceneBase);
        Scene: SceneBase;
        Materials: {
            [index: string]: ScMaterial;
        };
        GetOrAddMaterial<T extends ScMaterial>(c: {
            new (): T;
        }, name: string): T;
        GetMaterial<T extends ScMaterial>(c: {
            new (): T;
        }, name: string): ScMaterial;
        AddMaterial<T extends ScMaterial>(c: {
            new (): T;
        }, name: string): T;
        RemoveMaterial(entity: ScMaterial): void;
        Clear(): void;
    }
}
declare namespace U1.Views {
    class View2Canvas extends ViewBase {
        private _canvas;
        constructor(canvas: HTMLCanvasElement);
        Canvas: HTMLCanvasElement;
        protected CreateScene(): SceneBase;
    }
    class Scene2Canvas extends SceneBase {
        private _context;
        private _frustum;
        private static _temp_cavas;
        constructor(scene: ViewBase);
        newPoint(): ScPoint;
        newPolyLine(): ScPolyLine;
        newPolygon(): ScPolygon;
        newText(): ScText;
        newMesh(): ScMesh;
        newEllipse(): ScEllipse;
        Draw(): void;
        Clear(): void;
        private orign_point;
        private rectangles;
        protected OnBeginDraw(context: DrawContext): void;
        protected OnEndDraw(context: DrawContext): void;
        private _drawContext;
        protected CreateDrawContext(): DrawContext;
        MeasureTextureWidth(text: string, fontsize: number): number;
    }
    class DrawContext2Canvas extends DrawContext {
        constructor(scene: Scene2Canvas);
        RenderingContext2D: CanvasRenderingContext2D;
        ShowTextBounding: boolean;
        Dispose(): void;
    }
    class ScPoint2Canvas extends ScPoint {
        private static _p1;
        protected OnDraw(context: DrawContext): void;
    }
    class ScPolyLine2Canvas extends ScPolyLine {
        private static _p1;
        private static _p2;
        private static _p3;
        private static _empty_dash;
        protected OnDraw(context: DrawContext): void;
    }
    class ScPolygon2Canvas extends ScPolygon {
        private static _p1;
        private static _p2;
        private static _p3;
        private static _empty_dash;
        protected OnDraw(context: DrawContext): void;
    }
    class ScText2Canvas extends ScText {
        private static unit_x;
        private static _p0;
        private static _p1;
        private static _p2;
        private static _p3;
        private static _p4;
        private static _p5;
        private static _p6;
        private static _p7;
        protected OnDraw(context: DrawContext): void;
    }
    class ScMesh2Canvas extends ScMesh {
        protected OnDraw(context: DrawContext): void;
    }
    class ScEllipseCanvas extends ScEllipse {
        private static _p0;
        private static _p1;
        protected OnDraw(context: DrawContext): void;
    }
}
declare namespace U1.Views {
    class VcTool {
        private _active;
        private _view;
        View: ViewBase;
        OnAttach(view: ViewBase): void;
        OnDetach(view: ViewBase): void;
        OnMouseMove(ev: MouseEvent): boolean;
        OnMouseUp(ev: MouseEvent): boolean;
        OnMouseDown(ev: MouseEvent): boolean;
        OnMouseWheel(ev: MouseWheelEvent): boolean;
        OnPress(ev: HammerInput): boolean;
        OnPanMove(ev: HammerInput): boolean;
        OnPanStart(ev: HammerInput): boolean;
        OnPanEnd(ev: HammerInput): boolean;
        OnPinch(ev: HammerInput): boolean;
        OnTouchStart(ev: TouchEvent): boolean;
        OnTouchMove(ev: TouchEvent): boolean;
        OnTouchEnd(ev: TouchEvent): boolean;
    }
    class DefaultTool extends VcTool {
        constructor();
        OnAttach(view: ViewBase): void;
        OnDetach(view: ViewBase): void;
        private isPanning;
        OnMouseMove(ev: MouseEvent): boolean;
        OnMouseUp(ev: MouseEvent): boolean;
        OnMouseDown(ev: MouseEvent): boolean;
        OnMouseWheel(ev: MouseWheelEvent): boolean;
        OnPanMove(ev: HammerInput): boolean;
        OnPanStart(ev: HammerInput): boolean;
        OnPanEnd(ev: HammerInput): boolean;
        OnPinch(ev: HammerInput): boolean;
        OnTouchStart(ev: TouchEvent): boolean;
        OnTouchMove(ev: TouchEvent): boolean;
        OnTouchEnd(ev: TouchEvent): boolean;
        protected Finish(): void;
    }
}
declare namespace U1.Views {
    class VcXForm2 extends VControl {
        private static _tmp_m0;
        private static _tmp_m1;
        private static _tmp_v30;
        private static _tmp_v31;
        private static _tmp_v32;
        private static _radius;
        private static _fillcolor;
        private m_selected_nodes;
        private m_curObb;
        private m_oldObb;
        private m_mode;
        private m_prev_loc;
        private m_cur_loc;
        private m_active_hp;
        private m_points;
        CurOBB: OrientedBox3;
        CheckIntersect(isectContext: ISectContext): U1.ISectInfo;
        private GetIntersectNode(screen_pos);
        Init(nodes: Array<ScEntity>): void;
        Update(): void;
        Clear(): void;
        OnMouseMove(ev: MouseEvent): boolean;
        OnMouseUp(ev: MouseEvent): boolean;
        OnMouseDown(ev: MouseEvent): boolean;
        OnMouseWheel(ev: MouseWheelEvent): boolean;
        OnPanMove(ev: HammerInput): boolean;
        OnPanStart(ev: HammerInput): boolean;
        OnPanEnd(ev: HammerInput): boolean;
        OnPinch(ev: HammerInput): boolean;
        Move(): boolean;
        PrepareTransform(): boolean;
        BeginTransform(): boolean;
        Translate(matrix: Matrix4): void;
        Scale(center: Vector3, p1: Vector3, p2: Vector3): void;
        EndTransform(): boolean;
        private ApplyMove();
        private ApplyRotate(center, axis, angle);
        private ApplyScale(center, p1, p2);
        CreateOBBScaleMatrix(obb: OrientedBox3, center: Vector3, from: Vector3, to: Vector3): Matrix4;
    }
}
declare namespace U1.Visualize {
    import Polygon2 = U1.CGAL.Polygon2;
    enum VisPrimitiveTypes {
        Points = 0,
        Lines = 1,
        Triangles = 2,
    }
    enum VisAttributeKinds {
        Color = 0,
        DiffuseColor = 1,
        SpecularColor = 2,
        LineColor = 3,
        MarkColor = 4,
        LineWeight = 5,
    }
    class VisPrimitiveData {
        Points: Vector3[];
        Normals: Vector3[];
        Colors: Color[];
        Indics: number[];
        PrimitiveType: VisPrimitiveTypes;
    }
    class VisAttributeBase {
    }
    class VisAttribute<T> extends VisAttributeBase {
        Value: T;
    }
    enum ColorTargets {
        Lines = 0,
        Marks = 1,
    }
    class VisSceneGraph {
        private _rootNodes;
        AddRootNode(name: string): VisNode;
        GetRootNode(name: string): VisNode;
    }
    class VisNode {
        EID: number;
        AttrVer: number;
        TransformVer: number;
        GeometryVer: number;
        Transform: Matrix4;
        Parent: VisNode;
        Children: Array<VisNode>;
        Geometries: Array<VisGeometry>;
        MarkGeometryChanged(): VisNode;
        MarkTransformChanged(): VisNode;
        private _attrs;
        private SetAttr<T>(key, value);
        private GetAttr<T>(key);
        SetColor(color: Color): VisNode;
        GetColor(): Color;
        InsertGeometry(geometry: VisGeometry): void;
        RemoveGeometry(geometry: VisGeometry): void;
        RemoveChild(ch: VisNode): void;
    }
    class VisNodeInclude extends VisNode {
        Source: VisNode;
    }
    class VisGeometry {
        EID: number;
        Ver: number;
        Node: VisNode;
        private _boundingBox;
        private _boudningBoxInvalid;
        BoundingBox: BoundingBox;
        MarkChanged(): VisGeometry;
        GetPrimitiveData(): VisPrimitiveData;
        UpdateBoundingBox(boundingBox: BoundingBox): void;
    }
    enum VisFaceStates {
        None = 0,
        Cutted = 2,
        Cap = 4,
        Flat = 8,
    }
    class VisFace {
        private static s_handle;
        Handle: number;
        static TesselaterFunc: (face: VisFace, vertics: Vector3[]) => number[];
        constructor(boundary?: number[]);
        Boundary: number[];
        Holes: number[][];
        State: VisFaceStates;
        Normal: Vector3;
        IsFlat: boolean;
        IsCap: boolean;
        GetPointIndics(indics: {
            [index: number]: number;
        }): void;
        Clone(vertex_offset?: number): VisFace;
        ReplaceIndics(indicsMap: {
            [index: number]: number;
        }): void;
        UpdateNormal(vertics: Array<Vector3>): void;
        GetUV(u: Vector3, v: Vector3): void;
        static Project(p: Vector3, uaxis: Vector3, vaxis: Vector3): Vector2;
        static PlaneIntersection(polygon: number[], vertics: Array<Vector3>, plane: Plane): PlaneIntersectionTypeEnum;
        static GetCuttingEdges(polygon: Array<number>, vertics: Vector3[], plane: Plane, result: Array<number>): boolean;
        GetCuttingEdges(vertics: Vector3[], plane: Plane, result: Array<number>): boolean;
        GetPolygonWithHoles(vertics: Vector3[], vmap?: {
            [index: number]: number;
        }, v2map?: {
            [index: number]: number;
        }): U1.CGAL.PolygonWithHoles2;
        Tesselate(vertics: Vector3[]): Array<number>;
        static InsertIsectPoints(polygon: number[], vertics: Array<Vector3>, plane: Plane, add_point_func: (p: Vector3) => number, isect_points: Array<Vector3>, result: {
            new_polygon: Array<number>;
            insert_indics: Array<number>;
        }): boolean;
        Cut(vertics: Vector3[], plane: Plane, add_point_func: (p: Vector3) => number, fronts: Array<VisFace>, backs: Array<VisFace>): boolean;
    }
    class VisFaceCutter {
        static SplitFace(face: VisFace, vertics: Array<Vector3>, plane: Plane, insert_points: Array<Vector3>, front_faces: Array<VisFace>, back_faces: Array<VisFace>): boolean;
        static IsFront(points: number[], vertics: Array<Vector3>, plane: Plane): boolean;
        static GetPolygon(b: number[], vertics: Array<Vector3>, normal: Vector3): U1.CGAL.Polygon2;
        static Contains(boundary: Polygon2, hole: number[], vertics: Array<Vector3>, normal: Vector3): boolean;
    }
    class VisShell extends VisGeometry {
        private _mesh;
        static EPSILON: number;
        static MaxCuttedCache: number;
        Vertics: Vector3[];
        VertexNormals: Vector3[];
        Colors: Color[];
        UVs: Vector2[];
        Faces: VisFace[];
        UpdateBoundingBox(boundingBox: BoundingBox): void;
        IntersectsBoundingBoxPlane(plane: Plane): PlaneIntersectionTypeEnum;
        Intersects(plane: Plane): PlaneIntersectionTypeEnum;
        GetMesh(): MeshData;
    }
}
declare namespace U1.WinCad.Models {
    enum WcWinTypeEnums {
        _1F_1W_TD_D_R = 0,
        _1F_1W_TD_D_L = 1,
        _1F_1W_TD_R = 2,
        _1F_1W_TD_L = 3,
        _1W_TD_D_R = 4,
        _1W_TD_D_L = 5,
        _1W_TD_R = 6,
        _1W_TD_L = 7,
        _1W_1F_1F_1F_UB_FP = 8,
        _4W_2F_T_R_FS = 9,
        _4W_2F_T_L_FS = 10,
        _2W_2F_T_R_FS = 11,
        _2W_2F_T_L_FS = 12,
        _1W_1F_I_PJ = 13,
        _WH_C = 14,
        _WH_N = 15,
        _1W_C_N_C = 16,
        _1W_R_N_C = 17,
        _1W_L_N_C = 18,
        _1W_R_V_C = 19,
        _1W_L_V_C = 20,
        _1W_C_N_H = 21,
        _1W_R_N_H = 22,
        _1W_L_N_H = 23,
        _1W_R_V_H = 24,
        _1W_L_V_H = 25,
        _2W_2F_FP = 26,
        _2W_I_PJ = 27,
        _6W_3F_R_FS = 28,
        _6W_3F_L_FS = 29,
        _3W_3W_UB_SS = 30,
        _1W_1F_R_PJ = 31,
        _1W_1F_L_PJ = 32,
        _2W_UB_2F_UB_R_FS = 33,
        _2W_UB_2F_UB_L_FS = 34,
        _8W_R_SS = 35,
        _8W_L_SS = 36,
        _4W_UB_CENTER = 37,
        _1W_SF = 38,
        _6W_1F_I_R_FS = 39,
        _6W_1F_I_L_FS = 40,
        _4W_4W_L_SS = 41,
        _3W_4W_UB_SS = 42,
        _3W_4F_UB_FS = 43,
        _12W_UB_R_SS = 44,
        _12W_UB_L_SS = 45,
        _1F_1 = 46,
        _1F_2 = 47,
        _3W_UB_2F_I_U_FS = 48,
        _2W_1F_PI = 49,
        _1W_1F_PI = 50,
        _2W_PI = 51,
        _1W_PI = 52,
        _2W_2F_UB_R = 53,
        _2W_2F_UB_L = 54,
        _2F_UB_I = 55,
        _2W_C = 56,
        _4W_4W_SS_R = 57,
        _4W_4W_SS_L = 58,
        _3W_3F_U = 59,
        _3W_3F_D = 60,
        _4Fix = 61,
        _12W_I_UB_SS_R = 62,
        _12W_I_UB_SS_L = 63,
        _1W_1F_T_D_R = 64,
        _1W_1F_T_D_L = 65,
        _1W_1F_T_R = 66,
        _1W_1F_T_L = 67,
        _1W_T_D_R = 68,
        _1W_T_D_L = 69,
        _1W_T_R = 70,
        _1W_T_L = 71,
        _2W_U_END_R = 72,
        _2W_U_END_L = 73,
        _1W_U_CB_PJ = 74,
        _1W_U_END_CB_PJ = 75,
        _2W_4W_R_SS = 76,
        _2W_4W_L_SS = 77,
        _1V_1F_1V_I_FP = 78,
        _1F_1F_2W_I_R = 79,
        _1F_1F_2W_I_L = 80,
        _1F_2W_1F_I_R = 81,
        _1F_2W_1F_I_L = 82,
        _1F_1V_1F_I_V = 83,
        _1F_1V_1F_I_J = 84,
        _1F_2V_V = 85,
        _1F_2V_J = 86,
        _2F_I_V = 87,
        _2F_I_J = 88,
        _1F_1W_1F_I_A = 89,
        _1F_2V_A = 90,
        _2F_I_A = 91,
        _1FIX_U_3 = 92,
        _1FIX_U_4 = 93,
        _4W_CS = 94,
        _3W_UB_CS = 95,
        _2W_UB_CS_R = 96,
        _2W_UB_CS_L = 97,
        _2W_CS_R = 98,
        _2W_CS_L = 99,
        _2W_P = 100,
        _8W_UB_R = 101,
        _8W_UB_L = 102,
        _6W_L = 103,
        _1W_PJ = 104,
        _1W_MF = 105,
        _2W_2W_CS_I_R = 106,
        _2W_2W_CS_I_L = 107,
        _3W_UB_1FIX_I = 108,
        _8W_CS_R = 109,
        _8W_CS_L = 110,
        _4W_CS_I_R = 111,
        _4W_CS_I_L = 112,
        _8W_R = 113,
        _8W_L = 114,
        _6W_UB_I_R = 115,
        _6W_UB_I_L = 116,
        _6W_R_SS = 117,
        _6W_L_SS = 118,
        _4W_R_SS = 119,
        _4W_L_SS = 120,
        _4W_I_R_SS = 121,
        _4W_I_L_SS = 122,
        _2W_2FIX_LR_R = 123,
        _2W_2FIX_LR_L = 124,
        _4W_4FIX_R = 125,
        _4W_4FIX_L = 126,
        _4W_2FIX_R = 127,
        _4W_1FIX_I_R = 128,
        _2W_2FIX_I_R = 129,
        _2W_2FIX_FS = 130,
        _4W_2FIX_L = 131,
        _2W_1FIX_I_R = 132,
        _4W_1FIX_I = 133,
        _3W_1FIX_I = 134,
        _2W_2FIX_I_L = 135,
        _2W_4FIX = 136,
        _2W_2FIX = 137,
        _2W_3FIX_I = 138,
        _2W_1FIX_I = 139,
        _2W_2FIX_I = 140,
        _2W_1FIX_I_L = 141,
        _2W_I = 142,
        _1W_4FIX_I = 143,
        _1W_3FIX_I = 144,
        _1W_2FIX_I = 145,
        _1W_1FIX_I = 146,
        _1W_FIX = 147,
        _1W_FIX_I = 148,
        _1W = 149,
        _3Fix_I = 150,
        _2Fix_I = 151,
        _4Fix_Rect = 152,
        _3Fix = 153,
        _2Fix = 154,
        _WH = 155,
        _Fix = 156,
        _3W_UB = 157,
        _3W_1_1_1 = 158,
        _2W_UB_Right = 159,
        _4W_LR = 160,
        _2W_UB_Left = 161,
        _3W_1_2_1 = 162,
        _4W_Center = 163,
        _2W_Right = 164,
        _2W_Left = 165,
        None = 166,
    }
    class WcWinTypeConverter {
        static Names: {
            [index: string]: WcWinTypeEnums;
        };
        static FromSting(str: string): WcWinTypeEnums;
        static ToSting(type: WcWinTypeEnums): string;
    }
}
declare namespace U1.WinCad.Models {
    var WinCreater: {
        [index: number]: {
            new (): WcWinElement;
        };
    };
    function FindWinType(elm: WcWinElement): string;
    class WcWinElement extends UElement {
        protected w: UFieldFloat;
        protected h: UFieldFloat;
        protected showInsectNet: UFieldBool;
        protected showDim: UFieldBool;
        protected w1: UFieldFloat;
        protected h1: UFieldFloat;
        protected hndlLocW: UFieldFloat;
        protected hndlLocH: UFieldFloat;
        W: number;
        H: number;
        ShowInsectNet: boolean;
        ShowDim: boolean;
        W1: number;
        H1: number;
        HndlLocW: number;
        HndlLocH: number;
        protected CanHaveInsectNet(): boolean;
        OnGetFields(fieldSet: U1.FieldSet): void;
        GetProperties(): UPropertyBase[];
    }
}
declare namespace U1.WinCad.Models {
    class _2W_1FIX_I_L extends WcWinElement {
        constructor();
        GetProperties(): UPropertyBase[];
    }
    class _2W_2FIX_I extends WcWinElement {
        constructor();
        GetProperties(): UPropertyBase[];
    }
    class _2W_1FIX_I extends WcWinElement {
        constructor();
        GetProperties(): UPropertyBase[];
    }
    class _2W_3FIX_I extends WcWinElement {
        constructor();
        GetProperties(): UPropertyBase[];
    }
    class _2W_2FIX extends WcWinElement {
        constructor();
        GetProperties(): UPropertyBase[];
    }
    class _2W_4FIX extends WcWinElement {
        constructor();
        GetProperties(): UPropertyBase[];
    }
    class _2W_2FIX_I_L extends WcWinElement {
        constructor();
        GetProperties(): UPropertyBase[];
    }
    class _2W_1FIX_I_R extends WcWinElement {
        constructor();
        GetProperties(): UPropertyBase[];
    }
    class _2W_2FIX_FS extends WcWinElement {
        constructor();
        GetProperties(): UPropertyBase[];
    }
    class _2W_2FIX_I_R extends WcWinElement {
        constructor();
        GetProperties(): UPropertyBase[];
    }
    class _2W_2FIX_LR_L extends WcWinElement {
        constructor();
        GetProperties(): UPropertyBase[];
    }
    class _2W_2FIX_LR_R extends WcWinElement {
        constructor();
        GetProperties(): UPropertyBase[];
    }
    class _1F_2W_1F_I_L extends WcWinElement {
        constructor();
        GetProperties(): UPropertyBase[];
    }
    class _1F_2W_1F_I_R extends WcWinElement {
        constructor();
        GetProperties(): UPropertyBase[];
    }
    class _1F_1F_2W_I_L extends WcWinElement {
        constructor();
        GetProperties(): UPropertyBase[];
    }
    class _1F_1F_2W_I_R extends WcWinElement {
        constructor();
        GetProperties(): UPropertyBase[];
    }
    class _1F_2V_A extends WcWinElement {
        constructor();
        GetProperties(): UPropertyBase[];
    }
    class _1F_2V_J extends WcWinElement {
        constructor();
        GetProperties(): UPropertyBase[];
    }
    class _1F_2V_V extends WcWinElement {
        constructor();
        GetProperties(): UPropertyBase[];
    }
    class _2W_2F_UB_L extends WcWinElement {
        constructor();
        GetProperties(): UPropertyBase[];
    }
    class _2W_2F_UB_R extends WcWinElement {
        constructor();
        GetProperties(): UPropertyBase[];
    }
    class _2W_1F_PI extends WcWinElement {
        constructor();
        GetProperties(): UPropertyBase[];
    }
    class _2W_UB_2F_UB_L_FS extends WcWinElement {
        constructor();
        GetProperties(): UPropertyBase[];
    }
    class _2W_UB_2F_UB_R_FS extends WcWinElement {
        constructor();
        GetProperties(): UPropertyBase[];
    }
    class _2W_2F_FP extends WcWinElement {
        constructor();
        GetProperties(): UPropertyBase[];
    }
    class _2W_2F_T_L_FS extends WcWinElement {
        constructor();
        GetProperties(): UPropertyBase[];
    }
    class _2W_2F_T_R_FS extends WcWinElement {
        constructor();
        GetProperties(): UPropertyBase[];
    }
}
declare namespace U1.WinCad.Models {
    class _1W_FIX extends WcWinElement {
        constructor();
        GetProperties(): UPropertyBase[];
    }
    class _1W_FIX_I extends WcWinElement {
        constructor();
        GetProperties(): UPropertyBase[];
    }
    class _1W_1FIX_I extends WcWinElement {
        constructor();
        GetProperties(): UPropertyBase[];
    }
    class _1W_2FIX_I extends WcWinElement {
        constructor();
        GetProperties(): UPropertyBase[];
    }
    class _1W_3FIX_I extends WcWinElement {
        constructor();
        GetProperties(): UPropertyBase[];
    }
    class _1W_4FIX_I extends WcWinElement {
        constructor();
        GetProperties(): UPropertyBase[];
    }
    class _1F_1W_TD_L extends WcWinElement {
        constructor();
        GetProperties(): UPropertyBase[];
    }
    class _1F_1W_TD_R extends WcWinElement {
        constructor();
        GetProperties(): UPropertyBase[];
    }
    class _1F_1W_TD_D_L extends WcWinElement {
        constructor();
        GetProperties(): UPropertyBase[];
    }
    class _1F_1W_TD_D_R extends WcWinElement {
        constructor();
        GetProperties(): UPropertyBase[];
    }
    class _1F_1W_1F_I_A extends WcWinElement {
        constructor();
        GetProperties(): UPropertyBase[];
    }
    class _1F_1V_1F_I_J extends WcWinElement {
        constructor();
        GetProperties(): UPropertyBase[];
    }
    class _1F_1V_1F_I_V extends WcWinElement {
        constructor();
        GetProperties(): UPropertyBase[];
    }
    class _1V_1F_1V_I_FP extends WcWinElement {
        constructor();
        GetProperties(): UPropertyBase[];
    }
    class _1W_1F_T_L extends WcWinElement {
        constructor();
        GetProperties(): UPropertyBase[];
    }
    class _1W_1F_T_R extends WcWinElement {
        constructor();
        GetProperties(): UPropertyBase[];
    }
    class _1W_1F_T_D_L extends WcWinElement {
        constructor();
        GetProperties(): UPropertyBase[];
    }
    class _1W_1F_T_D_R extends WcWinElement {
        constructor();
        GetProperties(): UPropertyBase[];
    }
    class _1W_1F_PI extends WcWinElement {
        constructor();
        GetProperties(): UPropertyBase[];
    }
    class _1W_1F_L_PJ extends WcWinElement {
        constructor();
        GetProperties(): UPropertyBase[];
    }
    class _1W_1F_R_PJ extends WcWinElement {
        constructor();
        GetProperties(): UPropertyBase[];
    }
    class _1W_1F_1F_1F_UB_FP extends WcWinElement {
        constructor();
        GetProperties(): UPropertyBase[];
    }
    class _1W_1F_I_PJ extends WcWinElement {
        constructor();
        GetProperties(): UPropertyBase[];
    }
}
declare namespace U1.WinCad.Models {
    class _1W extends WcWinElement {
        constructor();
        /**
         * 핸들
         */
        GetProperties(): UPropertyBase[];
    }
    class _1W_MF extends WcWinElement {
        constructor();
    }
    class _1W_PJ extends WcWinElement {
        constructor();
    }
    class _1W_TD_L extends WcWinElement {
        constructor();
        /**
         * 핸들
         */
        GetProperties(): UPropertyBase[];
    }
    class _1W_TD_R extends WcWinElement {
        constructor();
        /**
         * 핸들
         */
        GetProperties(): UPropertyBase[];
    }
    class _1W_TD_D_L extends WcWinElement {
        constructor();
        /**
         * 핸들
         */
        GetProperties(): UPropertyBase[];
    }
    class _1W_TD_D_R extends WcWinElement {
        constructor();
        /**
         * 핸들
         */
        GetProperties(): UPropertyBase[];
    }
    class _1W_U_END_CB_PJ extends WcWinElement {
        constructor();
    }
    class _1W_U_CB_PJ extends WcWinElement {
        constructor();
    }
    class _1W_T_L extends WcWinElement {
        constructor();
        /**
         * 핸들
         */
        GetProperties(): UPropertyBase[];
    }
    class _1W_T_R extends WcWinElement {
        constructor();
        /**
         * 핸들
         */
        GetProperties(): UPropertyBase[];
    }
    class _1W_T_D_L extends WcWinElement {
        constructor();
        /**
         * 핸들
         */
        GetProperties(): UPropertyBase[];
    }
    class _1W_T_D_R extends WcWinElement {
        constructor();
        /**
         * 핸들
         */
        GetProperties(): UPropertyBase[];
    }
    class _1W_PI extends WcWinElement {
        constructor();
    }
    class _1W_L_V_H extends WcWinElement {
        constructor();
        /**
         * 핸들
         */
        GetProperties(): UPropertyBase[];
    }
    class _1W_R_V_H extends WcWinElement {
        constructor();
        /**
         * 핸들
         */
        GetProperties(): UPropertyBase[];
    }
    class _1W_L_N_H extends WcWinElement {
        constructor();
        /**
         * 핸들
         */
        GetProperties(): UPropertyBase[];
    }
    class _1W_R_N_H extends WcWinElement {
        constructor();
        /**
         * 핸들
         */
        GetProperties(): UPropertyBase[];
    }
    class _1W_C_N_H extends WcWinElement {
        constructor();
    }
    class _1W_L_V_C extends WcWinElement {
        constructor();
        /**
         * 핸들
         */
        GetProperties(): UPropertyBase[];
    }
    class _1W_R_V_C extends WcWinElement {
        constructor();
        /**
         * 핸들
         */
        GetProperties(): UPropertyBase[];
    }
    class _1W_L_N_C extends WcWinElement {
        constructor();
    }
    class _1W_R_N_C extends WcWinElement {
        constructor();
    }
    class _1W_C_N_C extends WcWinElement {
        constructor();
    }
}
declare namespace U1.WinCad.Models {
    class _12W_I_UB_SS_L extends WcWinElement {
        constructor();
        GetProperties(): UPropertyBase[];
    }
    class _12W_I_UB_SS_R extends WcWinElement {
        constructor();
        GetProperties(): UPropertyBase[];
    }
    class _12W_UB_L_SS extends WcWinElement {
        constructor();
        GetProperties(): UPropertyBase[];
    }
    class _12W_UB_R_SS extends WcWinElement {
        constructor();
        GetProperties(): UPropertyBase[];
    }
}
declare namespace U1.WinCad.Models {
    class _6W_1F_I_L_FS extends WcWinElement {
        constructor();
        GetProperties(): UPropertyBase[];
    }
    class _6W_1F_I_R_FS extends WcWinElement {
        constructor();
        GetProperties(): UPropertyBase[];
    }
    class _6W_3F_L_FS extends WcWinElement {
        constructor();
        GetProperties(): UPropertyBase[];
    }
    class _6W_3F_R_FS extends WcWinElement {
        constructor();
        GetProperties(): UPropertyBase[];
    }
}
declare namespace U1.WinCad.Models {
    class _8W_L extends WcWinElement {
        constructor();
    }
    class _8W_R extends WcWinElement {
        constructor();
    }
    class _8W_CS_L extends WcWinElement {
        constructor();
        GetProperties(): UPropertyBase[];
    }
    class _8W_CS_R extends WcWinElement {
        constructor();
        GetProperties(): UPropertyBase[];
    }
    class _8W_UB_L extends WcWinElement {
        constructor();
        GetProperties(): UPropertyBase[];
    }
    class _8W_UB_R extends WcWinElement {
        constructor();
        GetProperties(): UPropertyBase[];
    }
    class _8W_L_SS extends WcWinElement {
        constructor();
    }
    class _8W_R_SS extends WcWinElement {
        constructor();
    }
    class _4W_4W_L_SS extends WcWinElement {
        constructor();
        GetProperties(): UPropertyBase[];
    }
}
declare namespace U1.WinCad.Models {
    class _6W_L_SS extends WcWinElement {
        constructor();
    }
    class _6W_R_SS extends WcWinElement {
        constructor();
    }
    class _6W_UB_I_L extends WcWinElement {
        constructor();
        GetProperties(): UPropertyBase[];
    }
    class _6W_UB_I_R extends WcWinElement {
        constructor();
        GetProperties(): UPropertyBase[];
    }
    class _2W_4W_L_SS extends WcWinElement {
        constructor();
        GetProperties(): UPropertyBase[];
    }
    class _2W_4W_R_SS extends WcWinElement {
        constructor();
        GetProperties(): UPropertyBase[];
    }
    class _6W_L extends WcWinElement {
        constructor();
    }
}
declare namespace U1.WinCad.Models {
    class _4W_1FIX_I extends WcWinElement {
        constructor();
        GetProperties(): UPropertyBase[];
    }
    class _4W_2FIX_L extends WcWinElement {
        constructor();
        GetProperties(): UPropertyBase[];
    }
    class _4W_1FIX_I_R extends WcWinElement {
        constructor();
        GetProperties(): UPropertyBase[];
    }
    class _4W_2FIX_R extends WcWinElement {
        constructor();
        GetProperties(): UPropertyBase[];
    }
    class _4W_4FIX_L extends WcWinElement {
        constructor();
        GetProperties(): UPropertyBase[];
    }
    class _4W_4FIX_R extends WcWinElement {
        constructor();
        GetProperties(): UPropertyBase[];
    }
    class _4W_2F_T_L_FS extends WcWinElement {
        constructor();
        GetProperties(): UPropertyBase[];
    }
    class _4W_2F_T_R_FS extends WcWinElement {
        constructor();
        GetProperties(): UPropertyBase[];
    }
}
declare namespace U1.WinCad.Models {
    class _3W_1FIX_I extends WcWinElement {
        constructor();
        GetProperties(): UPropertyBase[];
    }
    class _3W_UB_1FIX_I extends WcWinElement {
        constructor();
        GetProperties(): UPropertyBase[];
    }
    class _3W_UB_2F_I_U_FS extends WcWinElement {
        constructor();
        GetProperties(): UPropertyBase[];
    }
    class _3W_4F_UB_FS extends WcWinElement {
        constructor();
        GetProperties(): UPropertyBase[];
    }
    class _3W_3W_UB_SS extends WcWinElement {
        constructor();
        GetProperties(): UPropertyBase[];
    }
    class _3W_3F_D extends WcWinElement {
        constructor();
        GetProperties(): UPropertyBase[];
    }
    class _3W_3F_U extends WcWinElement {
        constructor();
        GetProperties(): UPropertyBase[];
    }
    class _3W_4W_UB_SS extends WcWinElement {
        constructor();
        GetProperties(): UPropertyBase[];
    }
}
declare namespace U1.WinCad.Models {
    class _Fix extends WcWinElement {
        constructor();
        protected CanHaveInsectNet(): boolean;
    }
    class _2Fix extends WcWinElement {
        protected CanHaveInsectNet(): boolean;
    }
    class _3Fix extends WcWinElement {
        constructor();
        protected CanHaveInsectNet(): boolean;
    }
    class _4Fix extends WcWinElement {
        constructor();
        protected CanHaveInsectNet(): boolean;
    }
    class _2Fix_I extends WcWinElement {
        constructor();
        protected CanHaveInsectNet(): boolean;
    }
    class _3Fix_I extends WcWinElement {
        constructor();
        protected CanHaveInsectNet(): boolean;
    }
    class _4Fix_Rect extends WcWinElement {
        constructor();
        protected CanHaveInsectNet(): boolean;
    }
    class _1FIX_U_4 extends WcWinElement {
        constructor();
        protected CanHaveInsectNet(): boolean;
    }
    class _1FIX_U_3 extends WcWinElement {
        constructor();
        protected CanHaveInsectNet(): boolean;
    }
    class _2F_I_A extends WcWinElement {
        constructor();
        GetProperties(): UPropertyBase[];
    }
    class _2F_I_J extends WcWinElement {
        constructor();
        GetProperties(): UPropertyBase[];
    }
    class _2F_I_V extends WcWinElement {
        constructor();
        GetProperties(): UPropertyBase[];
    }
    class _2F_UB_I extends WcWinElement {
        constructor();
        GetProperties(): UPropertyBase[];
    }
    class _1F_2 extends WcWinElement {
        constructor();
        GetProperties(): UPropertyBase[];
    }
    class _1F_1 extends WcWinElement {
        constructor();
        GetProperties(): UPropertyBase[];
    }
    class _WH_N extends WcWinElement {
        constructor();
        protected CanHaveInsectNet(): boolean;
    }
    class _WH_C extends WcWinElement {
        constructor();
        protected CanHaveInsectNet(): boolean;
    }
}
declare namespace U1.WinCad.Models {
    class WcDocument extends UDocument {
        ActWin: WcWinElement;
    }
}
declare namespace U1.WinCad.Models {
    class _2W_Left extends WcWinElement {
    }
    class _2W_Right extends WcWinElement {
    }
    class _2W_UB_Left extends WcWinElement {
        GetProperties(): UPropertyBase[];
    }
    class _2W_UB_Right extends WcWinElement {
        GetProperties(): UPropertyBase[];
    }
    class _2W_I extends WcWinElement {
        constructor();
    }
    class _2W_P extends WcWinElement {
        GetProperties(): UPropertyBase[];
    }
    class _2W_CS_Left extends WcWinElement {
    }
    class _2W_CS_Right extends WcWinElement {
    }
    class _2W_UB_CS_Left extends WcWinElement {
        GetProperties(): UPropertyBase[];
    }
    class _2W_UB_CS_Right extends WcWinElement {
        GetProperties(): UPropertyBase[];
    }
    class _2W_U_END_L extends WcWinElement {
        constructor();
    }
    class _2W_U_END_R extends WcWinElement {
        constructor();
    }
    class _2W_C extends WcWinElement {
        constructor();
        GetProperties(): UPropertyBase[];
    }
    class _2W_PI extends WcWinElement {
        GetProperties(): UPropertyBase[];
    }
    class _2W_I_PJ extends WcWinElement {
        constructor();
        GetProperties(): UPropertyBase[];
    }
}
declare namespace U1.WinCad.Models {
    class _3W_1_2_1 extends WcWinElement {
        constructor();
    }
    class _3W_1_1_1 extends WcWinElement {
        constructor();
    }
    class _3W_UB extends WcWinElement {
        constructor();
        GetProperties(): UPropertyBase[];
    }
    class _3W_UB_CS extends WcWinElement {
        constructor();
        GetProperties(): UPropertyBase[];
    }
}
declare namespace U1.WinCad.Models {
    class _4W_Center extends WcWinElement {
        constructor();
    }
    class _4W_LR extends WcWinElement {
        constructor();
    }
    class _4W_I_L_SS extends WcWinElement {
        constructor();
        GetProperties(): UPropertyBase[];
    }
    class _4W_I_R_SS extends WcWinElement {
        constructor();
        GetProperties(): UPropertyBase[];
    }
    class _4W_L_SS extends WcWinElement {
        constructor();
    }
    class _4W_R_SS extends WcWinElement {
        constructor();
    }
    class _4W_CS_I_L extends WcWinElement {
        constructor();
        GetProperties(): UPropertyBase[];
    }
    class _4W_CS_I_R extends WcWinElement {
        constructor();
        GetProperties(): UPropertyBase[];
    }
    class _2W_2W_CS_I_L extends WcWinElement {
        constructor();
        GetProperties(): UPropertyBase[];
    }
    class _2W_2W_CS_I_R extends WcWinElement {
        constructor();
        GetProperties(): UPropertyBase[];
    }
    class _4W_CS extends WcWinElement {
        constructor();
    }
    class _4W_4W_SS_L extends WcWinElement {
        constructor();
        GetProperties(): UPropertyBase[];
    }
    class _4W_4W_SS_R extends WcWinElement {
        constructor();
        GetProperties(): UPropertyBase[];
    }
    class _4W_UB_CENTER extends WcWinElement {
        constructor();
        GetProperties(): UPropertyBase[];
    }
}
declare namespace U1.WinCad.Models {
    class _WH extends WcWinElement {
        constructor();
        protected CanHaveInsectNet(): boolean;
    }
    class _1W_SF extends WcWinElement {
        constructor();
        protected CanHaveInsectNet(): boolean;
    }
}
declare namespace U1.WinCad.Panels {
    class PropertyPanel extends UIControls.PanelBase {
        private static _current;
        private _actWin;
        static Current: PropertyPanel;
        constructor();
        private activeWinType;
        WcDoc: Models.WcDocument;
        WinTypes: string[];
        ActiveWinType: string;
        ActWin: Models.WcWinElement;
        private old_props;
        Properties: Array<UPropertyBase>;
        Show(panel: HTMLElement): void;
        protected InitBinders(): void;
        private OnDocumentChanged(doc);
    }
}
declare namespace U1.WinCad.Presenters {
    class WcDocumentPresenter extends U1.Views.UDocumentPresenter {
        private isInvalid;
        protected CreatePresenter(elm_: UElement): U1.Views.UElementPresenter;
        Update(): void;
        protected OnAfterAbortTransaction(doc: UDocument): void;
        protected OnAfterEndTransaction(doc: UDocument): void;
        protected OnAfterUndoRedo(doc: UDocument, isUndo: boolean): void;
        protected OnAfterLoaded(doc: UDocument): void;
    }
}
declare namespace U1.WinCad.Presenters {
    var PresenterCreater: {
        [index: number]: {
            new (): WcWinElementPresenter;
        };
    };
    class WcWinElementPresenter extends U1.Views.UElementPresenter {
        protected frameThick(): number;
        protected frameFill(): Color;
        protected frameStroke(): Color;
        protected barThick(): number;
        protected barFill(): Color;
        protected barStroke(): Color;
        protected dimFontSize(): number;
        protected dimOffset(): number;
        protected winFrameThick(): number;
        protected winFrameFill(): Color;
        protected winFrameStroke(): Color;
        protected winFill(): Color;
        protected winStroke(): Color;
        protected gbThick(): number;
        protected gbFill(): Color;
        protected gbStroke(): Color;
        protected hndlStroke(): Color;
        protected hndlFill(): Color;
        protected _rootEntity: U1.Views.ScGroup;
        protected _dims: U1.Views.VcDimension[];
        WcDoc: Models.WcDocument;
        WcDocPresenter: WcDocumentPresenter;
        WinElem: Models.WcWinElement;
        Update(): void;
        protected OnClear(): void;
        addEntity(entity: U1.Views.ScEntity): void;
        protected rootEntity(): Views.ScGroup;
        protected addFrame(rect: Rectangle, top?: boolean, left?: boolean, bottom?: boolean, right?: boolean): void;
        protected addLeftFrame(rect: Rectangle, top?: boolean, bottom?: boolean): U1.Views.ScEntity;
        protected addRightFrame(rect: Rectangle, top?: boolean, bottom?: boolean): U1.Views.ScEntity;
        protected addTopFrame(rect: Rectangle, left?: boolean, right?: boolean): U1.Views.ScEntity;
        protected addBottomFrame(rect: Rectangle, left?: boolean, right?: boolean): U1.Views.ScEntity;
        protected addBox(rect: Rectangle, stroke: Color, fill: Color): U1.Views.ScEntity;
        protected addVBar(topLoc: Vector2, height: number, top?: boolean, botttom?: boolean): Views.ScPolygon;
        protected addHBar(leftLoc: Vector2, width: number, left?: boolean, right?: boolean): Views.ScPolygon;
        private CreateVcDim();
        protected addLeftDim(orign: Vector2, topY: number, btmY: number, step?: number): Views.VcDimension;
        protected addRightDim(orign: Vector2, topY: number, btmY: number, step?: number): Views.VcDimension;
        protected addBottomDim(orign: Vector2, leftX: number, rightX: number, step?: number): Views.VcDimension;
        protected addTopDim(orign: Vector2, leftX: number, rightX: number, step?: number): Views.VcDimension;
        protected addWindow(rect: Rectangle, frame?: boolean, gb?: boolean): void;
        protected addLSide(rect: Rectangle, thick: number, stroke: Color, fill: Color, top?: boolean, bottom?: boolean): U1.Views.ScEntity;
        protected addRSide(rect: Rectangle, thick: number, stroke: Color, fill: Color, top?: boolean, bottom?: boolean): U1.Views.ScEntity;
        protected addTSide(rect: Rectangle, thick: number, stroke: Color, fill: Color, left?: boolean, right?: boolean): U1.Views.ScEntity;
        protected addBSide(rect: Rectangle, thick: number, stroke: Color, fill: Color, left?: boolean, right?: boolean): U1.Views.ScEntity;
        protected addOpenTrangle(rect: Rectangle, pading: number, dir: "L" | "R" | "U" | "D", stroke?: Color): Views.ScPolyLine;
        protected addCenterPlus(rect: Rectangle, size?: number, thick?: number, stroke?: Color): Views.ScGroup;
        protected addX(rect: Rectangle, thick?: number, stroke?: Color): Views.ScGroup;
        protected addCenterText(rect: Rectangle, text: string, fontSize?: number, fill?: Color): void;
        protected addCenterArrowL(rect: Rectangle, h?: number, w?: number, thick?: number, stroke?: Color): Views.ScGroup;
        protected addCenterArrowR(rect: Rectangle, h?: number, w?: number, thick?: number, stroke?: Color): Views.ScGroup;
        protected addCenterArrowLR(rect: Rectangle, h?: number, w?: number, thick?: number, stroke?: Color): Views.ScGroup;
        protected addVent(rect: Rectangle, size?: number, thick?: number, stroke?: Color): Views.ScGroup;
        /**
         *
         * @param rect
         * @param margin
         * @param angle 각도(degree)
         * @param span  라인 간격
         * @param thick
         * @param stroke
         */
        protected addLines(rect: Rectangle, margin?: number, angle?: number, span?: number, thick?: number, stroke?: Color): Views.ScGroup;
        protected addInsectNet(winregion: Rectangle, loc: "L" | "R"): Views.ScGroup;
        protected addCs(winregion: Rectangle, rate?: number): Views.ScGroup;
    }
}
declare namespace U1.WinCad.Presenters {
    class _2W_1FIX_I_L_Presenter extends WcWinElementPresenter {
        protected OnUpdate(): void;
    }
    class _2W_2FIX_I_Presenter extends WcWinElementPresenter {
        protected OnUpdate(): void;
    }
    class _2W_1FIX_I_Presenter extends WcWinElementPresenter {
        protected OnUpdate(): void;
    }
    class _2W_3FIX_I_Presenter extends WcWinElementPresenter {
        protected OnUpdate(): void;
    }
    class _2W_2FIX_Presenter extends WcWinElementPresenter {
        protected OnUpdate(): void;
    }
    class _2W_4FIX_Presenter extends WcWinElementPresenter {
        protected OnUpdate(): void;
    }
    class _2W_2FIX_I_L_Presenter extends WcWinElementPresenter {
        protected OnUpdate(): void;
    }
    class _2W_1FIX_I_R_Presenter extends WcWinElementPresenter {
        protected OnUpdate(): void;
    }
    class _2W_2FIX_FS_Presenter extends WcWinElementPresenter {
        protected OnUpdate(): void;
    }
    class _2W_2FIX_I_R_Presenter extends WcWinElementPresenter {
        protected OnUpdate(): void;
    }
    class _2W_2FIX_LR_L_Presenter extends WcWinElementPresenter {
        protected OnUpdate(): void;
    }
    class _2W_2FIX_LR_R_Presenter extends WcWinElementPresenter {
        protected OnUpdate(): void;
    }
    class _1F_2W_1F_I_L_Presenter extends WcWinElementPresenter {
        protected OnUpdate(): void;
    }
    class _1F_2W_1F_I_R_Presenter extends WcWinElementPresenter {
        protected OnUpdate(): void;
    }
    class _1F_1F_2W_I_L_Presenter extends WcWinElementPresenter {
        protected OnUpdate(): void;
    }
    class _1F_1F_2W_I_R_Presenter extends WcWinElementPresenter {
        protected OnUpdate(): void;
    }
    class _1F_2V_A_Presenter extends WcWinElementPresenter {
        protected OnUpdate(): void;
    }
    class _1F_2V_J_Presenter extends WcWinElementPresenter {
        protected OnUpdate(): void;
    }
    class _1F_2V_V_Presenter extends WcWinElementPresenter {
        protected OnUpdate(): void;
    }
    class _2W_2F_UB_L_Presenter extends WcWinElementPresenter {
        protected OnUpdate(): void;
    }
    class _2W_2F_UB_R_Presenter extends WcWinElementPresenter {
        protected OnUpdate(): void;
    }
    class _2W_1F_PI_Presenter extends WcWinElementPresenter {
        protected OnUpdate(): void;
    }
    class _2W_UB_2F_UB_L_FS_Presenter extends WcWinElementPresenter {
        protected OnUpdate(): void;
    }
    class _2W_UB_2F_UB_R_FS_Presenter extends WcWinElementPresenter {
        protected OnUpdate(): void;
    }
    class _2W_2F_FP_Presenter extends WcWinElementPresenter {
        protected OnUpdate(): void;
    }
    class _2W_2F_T_L_FS_Presenter extends WcWinElementPresenter {
        protected OnUpdate(): void;
    }
    class _2W_2F_T_R_FS_Presenter extends WcWinElementPresenter {
        protected OnUpdate(): void;
    }
}
declare namespace U1.WinCad.Presenters {
    class _1W_FIX_Presenter extends WcWinElementPresenter {
        protected OnUpdate(): void;
    }
    class _1W_FIX_I_Presenter extends WcWinElementPresenter {
        protected OnUpdate(): void;
    }
    class _1W_1FIX_I_Presenter extends WcWinElementPresenter {
        protected OnUpdate(): void;
    }
    class _1W_2FIX_I_Presenter extends WcWinElementPresenter {
        protected OnUpdate(): void;
    }
    class _1W_3FIX_I_Presenter extends WcWinElementPresenter {
        protected OnUpdate(): void;
    }
    class _1W_4FIX_I_Presenter extends WcWinElementPresenter {
        protected OnUpdate(): void;
    }
    class _1F_1W_TD_L_Presenter extends WcWinElementPresenter {
        protected OnUpdate(): void;
    }
    class _1F_1W_TD_R_Presenter extends WcWinElementPresenter {
        protected OnUpdate(): void;
    }
    class _1F_1W_TD_D_L_Presenter extends WcWinElementPresenter {
        protected OnUpdate(): void;
    }
    class _1F_1W_TD_D_R_Presenter extends WcWinElementPresenter {
        protected OnUpdate(): void;
    }
    class _1F_1W_1F_I_A_Presenter extends WcWinElementPresenter {
        protected OnUpdate(): void;
    }
    class _1F_1V_1F_I_J_Presenter extends WcWinElementPresenter {
        protected OnUpdate(): void;
    }
    class _1F_1V_1F_I_V_Presenter extends WcWinElementPresenter {
        protected OnUpdate(): void;
    }
    class _1V_1F_1V_I_FP_Presenter extends WcWinElementPresenter {
        protected OnUpdate(): void;
    }
    class _1W_1F_T_L_Presenter extends WcWinElementPresenter {
        protected OnUpdate(): void;
    }
    class _1W_1F_T_R_Presenter extends WcWinElementPresenter {
        protected OnUpdate(): void;
    }
    class _1W_1F_T_D_L_Presenter extends WcWinElementPresenter {
        protected OnUpdate(): void;
    }
    class _1W_1F_T_D_R_Presenter extends WcWinElementPresenter {
        protected OnUpdate(): void;
    }
    class _1W_1F_PI_Presenter extends WcWinElementPresenter {
        protected OnUpdate(): void;
    }
    class _1W_1F_L_PJ_Presenter extends WcWinElementPresenter {
        protected OnUpdate(): void;
    }
    class _1W_1F_R_PJ_Presenter extends WcWinElementPresenter {
        protected OnUpdate(): void;
    }
    class _1W_1F_1F_1F_UB_FP_Presenter extends WcWinElementPresenter {
        protected OnUpdate(): void;
    }
    class _1W_1F_I_PJ_Presenter extends WcWinElementPresenter {
        protected OnUpdate(): void;
    }
}
declare namespace U1.WinCad.Presenters {
    class _1W_Presenter extends WcWinElementPresenter {
        Win_1W: Models._1W;
        protected OnUpdate(): void;
    }
    class _1W_MF_Presenter extends WcWinElementPresenter {
        protected OnUpdate(): void;
    }
    class _1W_PJ_Presenter extends WcWinElementPresenter {
        Win_1W_PJ: Models._1W_PJ;
        protected OnUpdate(): void;
    }
    class _1W_TD_L_Presenter extends WcWinElementPresenter {
        Win_1W_TD_L: Models._1W_TD_L;
        protected OnUpdate(): void;
    }
    class _1W_TD_R_Presenter extends WcWinElementPresenter {
        Win_1W_TD_R: Models._1W_TD_R;
        protected OnUpdate(): void;
    }
    class _1W_TD_D_L_Presenter extends WcWinElementPresenter {
        Win_1W_TD_D_L: Models._1W_TD_D_L;
        protected OnUpdate(): void;
    }
    class _1W_TD_D_R_Presenter extends WcWinElementPresenter {
        Win_1W_TD_D_R: Models._1W_TD_D_R;
        protected OnUpdate(): void;
    }
    class _1W_U_END_CB_PJ_Presenter extends WcWinElementPresenter {
        Win_1W_PJ: Models._1W_PJ;
        protected OnUpdate(): void;
    }
    class _1W_U_CB_PJ_Presenter extends WcWinElementPresenter {
        Win_1W_PJ: Models._1W_PJ;
        protected OnUpdate(): void;
    }
    class _1W_T_L_Presenter extends WcWinElementPresenter {
        Win_1W_TD_L: Models._1W_TD_L;
        protected OnUpdate(): void;
    }
    class _1W_T_R_Presenter extends WcWinElementPresenter {
        Win_1W_TD_R: Models._1W_TD_R;
        protected OnUpdate(): void;
    }
    class _1W_T_D_L_Presenter extends WcWinElementPresenter {
        Win_1W_TD_D_L: Models._1W_TD_D_L;
        protected OnUpdate(): void;
    }
    class _1W_T_D_R_Presenter extends WcWinElementPresenter {
        Win_1W_TD_D_R: Models._1W_TD_D_R;
        protected OnUpdate(): void;
    }
    class _1W_PI_Presenter extends WcWinElementPresenter {
        Win_1W_PJ: Models._1W_PJ;
        protected OnUpdate(): void;
    }
    class _1W_L_V_H_Presenter extends WcWinElementPresenter {
        Win_1W_L_V_H: Models._1W_L_V_H;
        protected OnUpdate(): void;
    }
    class _1W_R_V_H_Presenter extends WcWinElementPresenter {
        Win_1W_R_V_H: Models._1W_R_V_H;
        protected OnUpdate(): void;
    }
    class _1W_L_N_H_Presenter extends WcWinElementPresenter {
        Win_1W_L_N_H: Models._1W_L_N_H;
        protected OnUpdate(): void;
    }
    class _1W_R_N_H_Presenter extends WcWinElementPresenter {
        Win_1W_R_N_H: Models._1W_R_N_H;
        protected OnUpdate(): void;
    }
    class _1W_C_N_H_Presenter extends WcWinElementPresenter {
        Win_1W_R_N_H: Models._1W_R_N_H;
        protected OnUpdate(): void;
    }
    class _1W_L_V_C_Presenter extends WcWinElementPresenter {
        Win_1W_R_V_H: Models._1W_R_V_H;
        protected OnUpdate(): void;
    }
    class _1W_R_V_C_Presenter extends WcWinElementPresenter {
        Win_1W_L_V_H: Models._1W_L_V_H;
        protected OnUpdate(): void;
    }
    class _1W_L_N_C_Presenter extends WcWinElementPresenter {
        Win_1W_R_N_H: Models._1W_R_N_H;
        protected OnUpdate(): void;
    }
    class _1W_R_N_C_Presenter extends WcWinElementPresenter {
        Win_1W_L_N_H: Models._1W_L_N_H;
        protected OnUpdate(): void;
    }
    class _1W_C_N_C_Presenter extends WcWinElementPresenter {
        Win_1W_R_N_H: Models._1W_R_N_H;
        protected OnUpdate(): void;
    }
}
declare namespace U1.WinCad.Presenters {
    class _2W_Left_Presenter extends WcWinElementPresenter {
        Win_2W_Left: Models._2W_Left;
        protected OnUpdate(): void;
    }
    class _2W_Right_Presenter extends WcWinElementPresenter {
        Win_2W_Right: Models._2W_Right;
        protected OnUpdate(): void;
    }
    class _2W_UB_Left_Presenter extends WcWinElementPresenter {
        protected OnUpdate(): void;
    }
    class _2W_UB_Right_Presenter extends WcWinElementPresenter {
        protected OnUpdate(): void;
    }
    class _2W_I_Presenter extends WcWinElementPresenter {
        protected OnUpdate(): void;
    }
    class _2W_P_Presenter extends WcWinElementPresenter {
        protected OnUpdate(): void;
    }
    class _2W_CS_Left_Presenter extends WcWinElementPresenter {
        Win_2W_Left: Models._2W_Left;
        protected OnUpdate(): void;
    }
    class _2W_CS_Right_Presenter extends WcWinElementPresenter {
        Win_2W_Right: Models._2W_Right;
        protected OnUpdate(): void;
    }
    class _2W_UB_CS_Left_Presenter extends WcWinElementPresenter {
        protected OnUpdate(): void;
    }
    class _2W_UB_CS_Right_Presenter extends WcWinElementPresenter {
        protected OnUpdate(): void;
    }
    class _2W_U_END_L_Presenter extends WcWinElementPresenter {
        protected OnUpdate(): void;
    }
    class _2W_U_END_R_Presenter extends WcWinElementPresenter {
        protected OnUpdate(): void;
    }
    class _2W_C_Presenter extends WcWinElementPresenter {
        protected OnUpdate(): void;
    }
    class _2W_PI_Presenter extends WcWinElementPresenter {
        protected OnUpdate(): void;
    }
    class _2W_I_PJ_Presenter extends WcWinElementPresenter {
        protected OnUpdate(): void;
    }
}
declare namespace U1.WinCad.Presenters {
    class _12W_I_UB_SS_L_Presenter extends WcWinElementPresenter {
        protected OnUpdate(): void;
    }
    class _12W_I_UB_SS_R_Presenter extends WcWinElementPresenter {
        protected OnUpdate(): void;
    }
    class _12W_UB_L_SS_Presenter extends WcWinElementPresenter {
        protected OnUpdate(): void;
    }
    class _12W_UB_R_SS_Presenter extends WcWinElementPresenter {
        protected OnUpdate(): void;
    }
}
declare namespace U1.WinCad.Presenters {
    class _6W_1F_I_L_FS_Presenter extends WcWinElementPresenter {
        protected OnUpdate(): void;
    }
    class _6W_1F_I_R_FS_Presenter extends WcWinElementPresenter {
        protected OnUpdate(): void;
    }
    class _6W_3F_L_FS_Presenter extends WcWinElementPresenter {
        protected OnUpdate(): void;
    }
    class _6W_3F_R_FS_Presenter extends WcWinElementPresenter {
        protected OnUpdate(): void;
    }
}
declare namespace U1.WinCad.Presenters {
    class _8W_L_Presenter extends WcWinElementPresenter {
        protected OnUpdate(): void;
    }
    class _8W_R_Presenter extends WcWinElementPresenter {
        protected OnUpdate(): void;
    }
    class _8W_CS_L_Presenter extends WcWinElementPresenter {
        protected OnUpdate(): void;
    }
    class _8W_CS_R_Presenter extends WcWinElementPresenter {
        protected OnUpdate(): void;
    }
    class _8W_UB_L_Presenter extends WcWinElementPresenter {
        protected OnUpdate(): void;
    }
    class _8W_UB_R_Presenter extends WcWinElementPresenter {
        protected OnUpdate(): void;
    }
    class _8W_L_SS_Presenter extends WcWinElementPresenter {
        protected OnUpdate(): void;
    }
    class _8W_R_SS_Presenter extends WcWinElementPresenter {
        protected OnUpdate(): void;
    }
    class _4W_4W_L_SS_Presenter extends WcWinElementPresenter {
        protected OnUpdate(): void;
    }
}
declare namespace U1.WinCad.Presenters {
    class _4W_1FIX_I_Presenter extends WcWinElementPresenter {
        protected OnUpdate(): void;
    }
    class _4W_2FIX_L_Presenter extends WcWinElementPresenter {
        protected OnUpdate(): void;
    }
    class _4W_1FIX_I_R_Presenter extends WcWinElementPresenter {
        protected OnUpdate(): void;
    }
    class _4W_2FIX_R_Presenter extends WcWinElementPresenter {
        protected OnUpdate(): void;
    }
    class _4W_4FIX_L_Presenter extends WcWinElementPresenter {
        protected OnUpdate(): void;
    }
    class _4W_4FIX_R_Presenter extends WcWinElementPresenter {
        protected OnUpdate(): void;
    }
    class _4W_2F_T_L_FS_Presenter extends WcWinElementPresenter {
        protected OnUpdate(): void;
    }
    class _4W_2F_T_R_FS_Presenter extends WcWinElementPresenter {
        protected OnUpdate(): void;
    }
}
declare namespace U1.WinCad.Presenters {
    class _3W_1FIX_I_Presenter extends WcWinElementPresenter {
        protected OnUpdate(): void;
    }
    class _3W_UB_1FIX_I_Presenter extends WcWinElementPresenter {
        protected OnUpdate(): void;
    }
    class _3W_UB_2F_I_U_FS_Presenter extends WcWinElementPresenter {
        protected OnUpdate(): void;
    }
    class _3W_4F_UB_FS_Presenter extends WcWinElementPresenter {
        protected OnUpdate(): void;
    }
    class _3W_3W_UB_SS_Presenter extends WcWinElementPresenter {
        protected OnUpdate(): void;
    }
    class _3W_3F_D_Presenter extends WcWinElementPresenter {
        protected OnUpdate(): void;
    }
    class _3W_3F_U_Presenter extends WcWinElementPresenter {
        protected OnUpdate(): void;
    }
    class _3W_4W_UB_SS_Presenter extends WcWinElementPresenter {
        protected OnUpdate(): void;
    }
}
declare namespace U1.WinCad.Presenters {
    class _3W_1_2_1_Presenter extends WcWinElementPresenter {
        protected OnUpdate(): void;
    }
    class _3W_1_1_1_Presenter extends WcWinElementPresenter {
        protected OnUpdate(): void;
    }
    class _3W_UB_Presenter extends WcWinElementPresenter {
        protected OnUpdate(): void;
    }
    class _3W_UB_CS_Presenter extends WcWinElementPresenter {
        protected OnUpdate(): void;
    }
}
declare namespace U1.WinCad.Presenters {
    class _6W_L_SS_Presenter extends WcWinElementPresenter {
        protected OnUpdate(): void;
    }
    class _6W_R_SS_Presenter extends WcWinElementPresenter {
        protected OnUpdate(): void;
    }
    class _6W_UB_I_L_Presenter extends WcWinElementPresenter {
        protected OnUpdate(): void;
    }
    class _6W_UB_I_R_Presenter extends WcWinElementPresenter {
        protected OnUpdate(): void;
    }
    class _2W_4W_L_SS_Presenter extends WcWinElementPresenter {
        protected OnUpdate(): void;
    }
    class _2W_4W_R_SS_Presenter extends WcWinElementPresenter {
        protected OnUpdate(): void;
    }
    class _6W_L_Presenter extends WcWinElementPresenter {
        protected OnUpdate(): void;
    }
}
declare namespace U1.WinCad.Presenters {
    class _4W_Center_Presenter extends WcWinElementPresenter {
        protected OnUpdate(): void;
    }
    class _4W_LR_Presenter extends WcWinElementPresenter {
        protected OnUpdate(): void;
    }
    class _4W_I_L_SS_Presenter extends WcWinElementPresenter {
        protected OnUpdate(): void;
    }
    class _4W_I_R_SS_Presenter extends WcWinElementPresenter {
        protected OnUpdate(): void;
    }
    class _4W_L_SS_Presenter extends WcWinElementPresenter {
        protected OnUpdate(): void;
    }
    class _4W_R_SS_Presenter extends WcWinElementPresenter {
        protected OnUpdate(): void;
    }
    class _4W_CS_I_L_Presenter extends WcWinElementPresenter {
        protected OnUpdate(): void;
    }
    class _4W_CS_I_R_Presenter extends WcWinElementPresenter {
        protected OnUpdate(): void;
    }
    class _2W_2W_CS_I_L_Presenter extends WcWinElementPresenter {
        protected OnUpdate(): void;
    }
    class _2W_2W_CS_I_R_Presenter extends WcWinElementPresenter {
        protected OnUpdate(): void;
    }
    class _4W_CS_Presenter extends WcWinElementPresenter {
        protected OnUpdate(): void;
    }
    class _4W_4W_SS_L_Presenter extends WcWinElementPresenter {
        protected OnUpdate(): void;
    }
    class _4W_4W_SS_R_Presenter extends WcWinElementPresenter {
        protected OnUpdate(): void;
    }
    class _4W_UB_CENTER_Presenter extends WcWinElementPresenter {
        protected OnUpdate(): void;
    }
}
declare namespace U1.WinCad.Presenters {
    class _Fix_Presenter extends WcWinElementPresenter {
        protected OnUpdate(): void;
    }
    class _2Fix_Presenter extends WcWinElementPresenter {
        protected OnUpdate(): void;
    }
    class _3Fix_Presenter extends WcWinElementPresenter {
        protected OnUpdate(): void;
    }
    class _4Fix_Presenter extends WcWinElementPresenter {
        protected OnUpdate(): void;
    }
    class _2Fix_I_Presenter extends WcWinElementPresenter {
        protected OnUpdate(): void;
    }
    class _3Fix_I_Presenter extends WcWinElementPresenter {
        protected OnUpdate(): void;
    }
    class _4Fix_Rect_Presenter extends WcWinElementPresenter {
        protected OnUpdate(): void;
    }
    class _1FIX_U_4_Presenter extends WcWinElementPresenter {
        protected OnUpdate(): void;
    }
    class _1FIX_U_3_Presenter extends WcWinElementPresenter {
        protected OnUpdate(): void;
    }
    class _2F_I_A_Presenter extends WcWinElementPresenter {
        protected OnUpdate(): void;
    }
    class _2F_I_J_Presenter extends WcWinElementPresenter {
        protected OnUpdate(): void;
    }
    class _2F_I_V_Presenter extends WcWinElementPresenter {
        protected OnUpdate(): void;
    }
    class _2F_UB_I_Presenter extends WcWinElementPresenter {
        protected OnUpdate(): void;
    }
    class _1F_2_Presenter extends WcWinElementPresenter {
        protected OnUpdate(): void;
    }
    class _1F_1_Presenter extends WcWinElementPresenter {
        protected OnUpdate(): void;
    }
    class _WH_N_Presenter extends WcWinElementPresenter {
        protected OnUpdate(): void;
    }
    class _WH_C_Presenter extends WcWinElementPresenter {
        protected OnUpdate(): void;
    }
}
declare namespace U1.WinCad.Presenters {
    class _WH_Presenter extends WcWinElementPresenter {
        protected OnUpdate(): void;
    }
    class _1W_SF_Presenter extends WcWinElementPresenter {
        protected OnUpdate(): void;
    }
}
declare namespace U1.WinCad.Services {
    class LgWinService {
        private static _current;
        static Current: LgWinService;
        private _activeDocument;
        private _isInit;
        private _activeView;
        ActiveDocument: Models.WcDocument;
        ActiveView: U1.Views.ViewBase;
        Init(canvas: HTMLCanvasElement, board: HTMLElement): void;
        WinTypes: string[];
        SetWindowType(wintype: string): void;
        SetW(w: number): void;
        SetH(h: number): void;
        SetW1(w1: number): void;
        SetH1(h1: number): void;
        SetHndlLoc(hndlLoc: number): void;
        SetNet(net: boolean): void;
        private parseNum(v);
        private parseBool(v);
        SetParams(winType: string, w: number, h: number, w1: number, h1: number, hndlLoc: number, net: boolean): boolean;
        SaveImage(estNo: string, estNos: string, clSn: string, windLocSn: string): void;
    }
}
