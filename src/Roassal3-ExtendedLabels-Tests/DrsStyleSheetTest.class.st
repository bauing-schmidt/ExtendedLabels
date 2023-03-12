Class {
	#name : #DrsStyleSheetTest,
	#superclass : #TestCase,
	#category : #'Roassal3-ExtendedLabels-Tests'
}

{ #category : #tests }
DrsStyleSheetTest >> testClassNamedVariantsIfPresentDefault [

	| aStyleSheet found |
	aStyleSheet := DrsStyleSheet parse: '
.test { 
	color: #FF0000;
}'.

	found := aStyleSheet
		         classNamed: #test
		         variants: #( default )
		         ifPresent: [ :c | c ].
	self
		assert: (found propertyAt: #color) propertyString
		equals: '#FF0000'
]

{ #category : #tests }
DrsStyleSheetTest >> testClassNamedVariantsIfPresentDifferentOrder [

	| aStyleSheet found |
	aStyleSheet := DrsStyleSheet parse: '
.test select small abacus { 
	color: #FF0000;
}'.

	found := aStyleSheet
		         classNamed: #test
		         variants: #( abacus select small )
		         ifPresent: [ :c | c ].
	self assert: (found propertyAt: #color) isNil
]

{ #category : #tests }
DrsStyleSheetTest >> testClassNamedVariantsIfPresentNotFound1 [

	| aStyleSheet found |
	aStyleSheet := DrsStyleSheet parse: '
.test select small abacus { 
	color: #FF0000;
}'.

	found := aStyleSheet
		         classNamed: #test
		         variants: #( select small )
		         ifPresent: [ :c | c ].
	self assert: (found propertyAt: #color) isNil
]

{ #category : #tests }
DrsStyleSheetTest >> testClassNamedVariantsIfPresentNotFound2 [

	| aStyleSheet found |
	aStyleSheet := DrsStyleSheet parse: '
.test select small abacus { 
	color: #FF0000;
}'.

	found := aStyleSheet
		         classNamed: #test
		         variants: #(  )
		         ifPresent: [ :c | c ].
	self assert: (found propertyAt: #color) isNil
]

{ #category : #tests }
DrsStyleSheetTest >> testClassNamedVariantsIfPresentSameOrder [

	| aStyleSheet found |
	aStyleSheet := DrsStyleSheet parse: '
.test select small abacus { 
	color: #FF0000;
}'.

	found := aStyleSheet
		         classNamed: #test
		         variants: #( #default select small abacus )
		         ifPresent: [ :c | c ].
	self
		assert: (found propertyAt: #color) propertyString
		equals: '#FF0000'
]

{ #category : #tests }
DrsStyleSheetTest >> testComplexStyleDefinitions [ 
	"Check if the 1-char-indicators actually used do not lead to broken parsing"
	
	| styleSheet formatString1 formatString2 conditionString2 styleRule |
	formatString1 := '.[date-large] ?[dd_MMM_yyyy] #[ ] .[date-small] ?[hh:mm]'.
	formatString2 := '.[date-small] ?[MMM]_.[date-large] ?[yyyy]'.
	conditionString2 := '[$>=''1990-01-01'']&[$<''2000-01-01'']'.
	styleSheet := DrsStyleSheet parse: '
.historyTime-test  {
	conditionalLimit: "";
	textFormat: "', formatString1, '";
}
.historyTime-test  {
	conditionalLimit: "', conditionString2, '";
	textFormat: "', formatString2, '";
}'.
	styleRule := styleSheet children first.
	self assert: (styleRule propertyAt: #conditionalLimit) propertyString equals: '""'.		
	self assert: (styleRule propertyAt: #textFormat) propertyString equals: '"', formatString1 , '"'.		
	
	styleRule := styleSheet children last.
	self assert: (styleRule propertyAt: #conditionalLimit) propertyString equals: '"', conditionString2, '"'.		
	self assert: (styleRule propertyAt: #textFormat) propertyString equals: '"', formatString2 , '"'.
	"styleSheet inspect.	
	styleRule inspect."
]

{ #category : #tests }
DrsStyleSheetTest >> testPrivNonCachedStylesFromVariants1 [

	| aStyleSheet found |
	aStyleSheet := DrsStyleSheet parse: '
.test { 
	color: #FF0000;
}'.

	found := aStyleSheet
		         privNonCachedStylesFrom: #( test )
		         variants: #(  ).

	self
		assert: (found get: #color defaultValue: nil)
		equals: Color red
]

{ #category : #tests }
DrsStyleSheetTest >> testPrivNonCachedStylesFromVariants2 [

	| aStyleSheet found |
	aStyleSheet := DrsStyleSheet parse: '
.test { 
	color: #FF0000;
}'.

	found := aStyleSheet
		         privNonCachedStylesFrom: #( test )
		         variants: #( #default style ).

	self assert: (found get: #color defaultValue: nil) equals: Color red
]

{ #category : #tests }
DrsStyleSheetTest >> testPrivNonCachedStylesFromVariants3 [

	| aStyleSheet found |
	aStyleSheet := DrsStyleSheet parse: '
.test { 
   font-size: 10;
	color: #FF0000;
}

.test selected { 
	color: #0000FF;
}
'.

	found := aStyleSheet
		         privNonCachedStylesFrom: #( test )
		         variants: #( #noExisting ).

	self assert: (found get: #color defaultValue: nil) equals: Color red
]

{ #category : #tests }
DrsStyleSheetTest >> testPrivNonCachedStylesFromVariants4 [

	| aStyleSheet found |
	aStyleSheet := DrsStyleSheet parse: '
.test { 
   font-size: 10;
	color: #FF0000;
}

.test selected { 
	color: #0000FF;
}
'.

	found := aStyleSheet
		         privNonCachedStylesFrom: #( test )
		         variants: #( selected ).

	self assert: (found get: #color defaultValue: nil) equals: Color blue.
	self assert: (found get: #'font-size' defaultValue: nil) equals: 10
]

{ #category : #tests }
DrsStyleSheetTest >> testPrivNonCachedStylesFromVariants5 [

	| aStyleSheet found |
	aStyleSheet := DrsStyleSheet parse: '
.test { 
   font-size: 10;
	color: #FF0000;
}

.test selected { 
   font-size: 12;
	color: #0000FF;
}

.test selected green { 
	color: #00FF00;
}
'.

	found := aStyleSheet
		         privNonCachedStylesFrom: #( test )
		         variants: #( selected green ).

	self
		assert: (found get: #'font-size' defaultValue: nil)
		equals: 12.
	self assert: (found get: #color defaultValue: nil) equals: Color green
]

{ #category : #tests }
DrsStyleSheetTest >> testPrivNonCachedStylesFromVariants6 [

	| aStyleSheet found |
	aStyleSheet := DrsStyleSheet parse: '
.test { 
   font-size: 10;
	color: #FF0000;
}

.test selected { 
   font-size: 12;
	color: #0000FF;
}

.test selected green { 
	color: #00FF00;
}
'.

	found := aStyleSheet
		         privNonCachedStylesFrom: #( test )
		         variants: #( selected ).

	self assert: (found get: #'font-size' defaultValue: nil) equals: 12.
	self assert: (found get: #color defaultValue: nil) equals: Color blue
]

{ #category : #tests }
DrsStyleSheetTest >> testPrivNonCachedStylesFromVariants7 [

	| aStyleSheet found |

	self flag: #todo. "this is actually WRONG! We should prioritize the most specific style variants"

	aStyleSheet := DrsStyleSheet parse: '
.baseStyle { 
	font-face: "DejaVu Sans"
}

.baseStyle selected green { 
	color: #00FF00;
}	
	
.test { 
   font-size: 10;
	color: #FF0000;
}

.test selected { 
   font-size: 12;
	color: #0000FF;
}

'.

	found := aStyleSheet
		         privNonCachedStylesFrom: #( baseStyle test )
		         variants: #( selected green ).

	self
		assert: (found get: #'font-face' defaultValue: nil)
		equals: 'DejaVu Sans'.
	self assert: (found get: #'font-size' defaultValue: nil) equals: 12.
	self assert: (found get: #color defaultValue: nil) equals: Color blue
]

{ #category : #tests }
DrsStyleSheetTest >> testPrivNonCachedStylesFromVariants8 [

	| aStyleSheet found |
	aStyleSheet := DrsStyleSheet parse: '
.baseStyle { 
	font-face: "DejaVu Sans"
}

.baseStyle selected green { 
	color: #00FF00;
}	
	
.test { 
   font-size: 10;
	color: #FF0000;
}

.test selected { 
   font-size: 12;
	color: #0000FF;
}

.test selected green { 
	color: #000000;
}	
'.

	found := aStyleSheet
		         privNonCachedStylesFrom: #( baseStyle test )
		         variants: #( selected green ).

	self
		assert: (found get: #'font-face' defaultValue: nil)
		equals: 'DejaVu Sans'.
	self assert: (found get: #'font-size' defaultValue: nil) equals: 12.
	self
		assert: (found get: #color defaultValue: nil)
		equals: Color black
]

{ #category : #tests }
DrsStyleSheetTest >> testStylesFromVariants [

	| aStyleSheet found assignment configuration |
	aStyleSheet := DrsStyleSheet parse: '
.baseStyle { 
	font-face: "DejaVu Sans"
}

.baseStyle selected  { 
   borderWidth: 1;
	color: #00FF00;
}	
	
.test { 
   font-size: 10;
	color: #FF0000;
}

.test selected { 
   font-size: 12;
	color: #0000FF;
}

.test selected green { 
	color: #000000;
}	
'.

	assignment := DrsStylesAssignment styleClasses: #( .baseStyle .test ).
	configuration := DrsStyleConfiguration new addStyle: assignment.

	found := aStyleSheet
		         stylesFromConfigurations: { configuration }
		         variants: #( selected green ).

	self
		assert: (found get: #'font-face' defaultValue: nil)
		equals: 'DejaVu Sans'.
	self assert: (found get: #'font-size' defaultValue: nil) equals: 12.
	self assert: (found get: #'borderWidth' defaultValue: nil) equals: 1.
	self
		assert: (found get: #color defaultValue: nil)
		equals: Color black
]

{ #category : #tests }
DrsStyleSheetTest >> testTypeVariantClasses [ 

	"one class definition with 5 variants"

	| styleSheet variants ourVariants |
	
	styleSheet  := DrsStyleSheet parse: '
.historyTime-default  {
	conditionalLimit: "";
	textFormat: ".[date-large] ?[dd_MMM_yyyy] #[ ] .[date-small] ?[hh:mm]";
}
.historyTime-default {
	conditionalLimit: "[$=current(d,0)]";
	textFormat-de-: ".[date-small] #[heute ] .[date-large] ?[hh:mm]";
	textFormat-en-: ".[date-small] #[today ] .[date-large] ?[hh:mm]";
}
.historyTime-default  {
	conditionalLimit: "[$=current(d,-1)]";
	textFormat-de-: ".[date-small] #[gestern ] .[date-large] ?[hh:mm]";
	textFormat-en-: ".[date-small] #[yesterday ] .[date-large] ?[hh:mm]";
}
.historyTime-default  {
	conditionalLimit: "[$=current(w,0)]";
	textFormat: ".[date-small] ?[EEE] .[date-large] ?[hh:mm]";
}
.historyTime-default {
	conditionalLimit: "[$>=''1990-01-01'']&[$<''2000-01-01'']";
	textFormat: ".[date-small] ?[MMM_] .[date-large] ?[yyyy]";
}'.


	variants := styleSheet typeVariantsClasses.
	self assert: variants size equals: 1.
	ourVariants := variants at: 'historyTime-default'.
	self assert: ourVariants size equals: 5.
	"Mind that empty conditionalLimit (the default) is always added as last entry
	(taken from whereever it occurred). Other positions remain unchanged."
	self assert: (ourVariants last stylePropertyNamed: #conditionalLimit)
			equals: ''.		
	self assert: (ourVariants first stylePropertyNamed: #conditionalLimit) 
			equals: '[$=current(d,0)]'.
	
	

]

{ #category : #tests }
DrsStyleSheetTest >> testTypeVariantClassesMultiple [

	"two class definitions, each with two variants"

	| styleSheet variants defaultVariant specialVariant |
	
	styleSheet := DrsStyleSheet parse: '
.historyTime-default  {
	conditionalLimit: "";
	textFormat: ".[date-large] ?[dd_MMM_yyyy hh:mm]";
}
.historyTime-default {
	conditionalLimit: "[$<''2000-01-01'']";
	textFormat: ".[date-small] ?[MMM_] .[date-large] ?[yyyy]";
}
.historyTime-special  {
	conditionalLimit: "";
	textFormat: ".[date-large] ?[dd_MMM_yyyy ] .[date-small] ?[hh:mm]";
}
.historyTime-special {
	conditionalLimit: "[$<''1999-01-01'']";
	textFormat: ".[date-small] ?[MMM_] .[date-large] ?[yyyy]";
}
'.
	variants := styleSheet typeVariantsClasses.
	self assert: variants size equals: 2.
	defaultVariant := variants at: 'historyTime-default'.
	specialVariant := variants at: 'historyTime-special'.
	self assert: defaultVariant size equals: 2.
	self assert: (defaultVariant last stylePropertyNamed: #conditionalLimit) equals: ''.
	self assert: specialVariant size equals: 2.
	self assert: (specialVariant first stylePropertyNamed: #conditionalLimit) equals: '[$<''1999-01-01'']'.
	
	

]

{ #category : #tests }
DrsStyleSheetTest >> testTypeVariantWithLocalizedProperties [ 

	| defaultTextFormat styleSheet variants ourVariants localizedTextFormats |
	
	defaultTextFormat := '.[date-large] ?[dd_MMM_yyyy] #[ ] .[date-small] ?[hh:mm]'.
	styleSheet := DrsStyleSheet parse: '
.historyTime-default  {
	conditionalLimit: "";
	textFormat: "', defaultTextFormat, '";
}
.historyTime-default {
	conditionalLimit: "[$=current(d,0)]";
	textFormat-de-: ".[date-small] #[heute ] .[date-large] ?[hh:mm]";
	textFormat-en-: ".[date-small] #[today ] .[date-large] ?[hh:mm]";
}
.historyTime-default  {
	conditionalLimit: "[$=current(d,-1)]";
	textFormat-de-: ".[date-small] #[gestern ] .[date-large] ?[hh:mm]";
	textFormat-en-: ".[date-small] #[yesterday ] .[date-large] ?[hh:mm]";
}
.historyTime-default  {
	conditionalLimit: "[$=current(w,0)]";
	textFormat: ".[date-small] ?[EEE] .[date-large] ?[hh:mm]";
}'.

	variants := styleSheet typeVariantsClasses.
	self assert: variants size equals: 1.
	ourVariants := variants at: 'historyTime-default'.
	self assert: ourVariants size equals: 4.
	"Mind that empty conditionalLimit (the default) is always added as last entry
	(taken from whereever it occurred). Other positions remain unchanged."
	self assert: (ourVariants last stylePropertyNamed: #conditionalLimit)
			equals: ''.	
	self assert: (ourVariants first stylePropertyNamed: #conditionalLimit) 
			equals: '[$=current(d,0)]'.
	localizedTextFormats := ourVariants first propertiesNamed: #textFormat includeLocalized: true.
	self assert: localizedTextFormats size equals: 2.

]

{ #category : #tests }
DrsStyleSheetTest >> testTypeVariantWithLocalizedTextFormat [ 

	| defaultTextFormat styleSheet variants ourVariants testedVariant localizedTextFormats matchingProperty |
	
	defaultTextFormat := '.[date-large] ?[dd_MMM_yyyy] #[ ] .[date-small] ?[hh:mm]'.
	styleSheet := DrsStyleSheet parse: '
.historyTime-default  {
	conditionalLimit: "";
	textFormat: "', defaultTextFormat, '";
}
.historyTime-default {
	conditionalLimit: "[$=current(d,0)]";
	textFormat-en-: ".[date-small] #[today ] .[date-large] ?[hh:mm]";
	textFormat-de-: ".[date-small] #[heute ] .[date-large] ?[hh:mm]";
}
.historyTime-default  {
	conditionalLimit: "[$=current(d,-1)]";
	textFormat-de-: ".[date-small] #[gestern ] .[date-large] ?[hh:mm]";
	textFormat:     ".[date-small] #[yesterday ] .[date-large] ?[hh:mm]";
	textFormat-es-: ".[date-small] #[ayer ] .[date-large] ?[hh:mm]";
}
.historyTime-default  {
	conditionalLimit: "[$=current(w,0)]";
	textFormat: ".[date-small] ?[EEE] .[date-large] ?[hh:mm]";
}'.

	variants := styleSheet typeVariantsClasses.
	self assert: variants size equals: 1.
	ourVariants := variants at: 'historyTime-default'.
	self assert: ourVariants size equals: 4.
	"Mind that empty conditionalLimit (the default) is always added as last entry
	(taken from whereever it occurred). Other positions remain unchanged."
	self assert: (ourVariants last stylePropertyNamed: #conditionalLimit)
			equals: ''.	
	testedVariant := ourVariants first.
	self assert: (testedVariant stylePropertyNamed: #conditionalLimit) 
			equals: '[$=current(d,0)]'.
	"Test for correct precedence in collection without default"
	localizedTextFormats := testedVariant propertiesNamed: #textFormat includeLocalized: true.
	self assert: localizedTextFormats size equals: 2.
	matchingProperty := testedVariant findBestMatchForLocalized: #textFormat isoLanguage: 'de'.
	self assert: (matchingProperty value matches: '*[heute ]*').
	matchingProperty := testedVariant findBestMatchForLocalized: #textFormat isoLanguage: 'en'.
	self assert: (matchingProperty value matches: '*[today ]*').
	matchingProperty := testedVariant findBestMatchForLocalized: #textFormat isoLanguage: 'cn'.
	self assert: (matchingProperty value matches: '*[today ]*').

	"Test for correct precedence in collection containing default"
	testedVariant := ourVariants at: 2.
	self assert: (testedVariant stylePropertyNamed: #conditionalLimit) 
			equals: '[$=current(d,-1)]'.
	"Test for correct precedence in collection without default"
	localizedTextFormats := testedVariant propertiesNamed: #textFormat includeLocalized: true.
	self assert: localizedTextFormats size equals: 3.
	matchingProperty := testedVariant findBestMatchForLocalized: #textFormat isoLanguage: 'de'.
	self assert: (matchingProperty value matches: '*[gestern ]*').
	matchingProperty := testedVariant findBestMatchForLocalized: #textFormat isoLanguage: 'cn'.
	self assert: (matchingProperty value matches: '*[yesterday ]*').
	matchingProperty := testedVariant findBestMatchForLocalized: #textFormat isoLanguage: 'es'.
	self assert: (matchingProperty value matches: '*[ayer ]*').
	
]

{ #category : #tests }
DrsStyleSheetTest >> testVariantsCombinationsFrom [

	| styleSheet |
	styleSheet := DrsStyleSheet new.

	self assert: (styleSheet variantsCombinationsFrom: #(  )) isEmpty.
	self
		assert: (styleSheet variantsCombinationsFrom: #( first ))
		equals: { #( first ) }.

	self
		assert: (styleSheet variantsCombinationsFrom: #( first second ))
		equals: { 
				#( first ).
				#( first second ) }.

	self
		assert:
		(styleSheet variantsCombinationsFrom: #( first second third ))
		equals: { 
				#( first ).
				#( first second ).
				#( first second third ) }
]

{ #category : #tests }
DrsStyleSheetTest >> testVariantsCombinationsWithDefautlFrom [

	| styleSheet |
	styleSheet := DrsStyleSheet new.

	self
		assert: (styleSheet variantsCombinationsWithDefaultFrom: #(  ))
		equals: { #( default ) }.
	self
		assert: (styleSheet variantsCombinationsWithDefaultFrom: #( first ))
		equals: { 
				#( default ).
				#( default first ) }.

	self
		assert:
		(styleSheet variantsCombinationsWithDefaultFrom: #( first second ))
		equals: { 
				#( default ).
				#( default first ).
				#( default first second ) }
]
