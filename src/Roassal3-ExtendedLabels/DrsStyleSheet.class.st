Class {
	#name : #DrsStyleSheet,
	#superclass : #CSSStyleSheet,
	#instVars : [
		'styleClasses',
		'allClassesDefinitions',
		'stylesCache',
		'typeVariantsClasses'
	],
	#category : #'Roassal3-ExtendedLabels-Styles'
}

{ #category : #parsing }
DrsStyleSheet class >> parse: aString [ 

	| aStyleSheet |
	
	aStyleSheet := super parse: aString.
	aStyleSheet postLoad.
	
	^ aStyleSheet
]

{ #category : #accessing }
DrsStyleSheet >> classNamed: styleClassName ifPresent: aBlock [

	^ self classNamed: styleClassName variant: #default ifPresent: aBlock
]

{ #category : #accessing }
DrsStyleSheet >> classNamed: styleClassName variant: variantsColl ifPresent: aBlock [ 

  ^ self classNamed: styleClassName variants: {variantsColl} ifPresent: aBlock 


]

{ #category : #accessing }
DrsStyleSheet >> classNamed: styleClassName variants: variantsColl ifPresent: aBlock [

	| variantsDictionary |
	
	styleClasses ifNil: [ ^ nil ].

	variantsDictionary := styleClasses
		                      at: styleClassName
		                      ifAbsent: [ ^ nil ].

	^ aBlock cull: (variantsDictionary at: variantsColl ifAbsent: [ 
			   CSSDefaultStyleRule new
				   properties: #(  );
				   yourself ])
]

{ #category : #private }
DrsStyleSheet >> collectTypeVariantsClasses [
	| classesWithLimit |
	
	classesWithLimit := allClassesDefinitions 
		select: [ :each | 
			each properties anySatisfy: [ :aCSSStyleRule | 
				aCSSStyleRule propertyName = #conditionalLimit  ] ] 
		thenCollect: [ :each | each selector ].
	
	classesWithLimit := classesWithLimit removeDuplicates.
	
	classesWithLimit do: [ :classSelector |	| definitionsForTheSameClass distinctLimits defaultIndex | 
		definitionsForTheSameClass := allClassesDefinitions 
			select: [ :each | each selector = classSelector ] 
			thenCollect: [ :each | 
				(each propertyAt: #conditionalLimit) 
					-> (DrsStyleProperties new addStyleRule: each; yourself)
		].
		distinctLimits := Set new.
		defaultIndex := 0.
		definitionsForTheSameClass doWithIndex: [ :assoc :i | | prop |
			prop := assoc key.
			prop propertyString = '""' ifTrue: [ defaultIndex := i ].
			distinctLimits add: prop propertyString.
		].
		distinctLimits size = definitionsForTheSameClass size 
			ifFalse: [ self pdmError: #StylesConditionalLimitsNotUnique attribute: classSelector ].
		defaultIndex = 0
			ifTrue: [ self pdmError: #StylesConditionalLimitsMissingDefault attribute: classSelector ].
		"default limit (no limit) has always to be the last one"
		definitionsForTheSameClass add: (definitionsForTheSameClass removeAt: defaultIndex).
		typeVariantsClasses
			at: (classSelector selectors first value withoutPrefix: '.')
			put: (definitionsForTheSameClass collect: [ :e | e value ])
	].

]

{ #category : #'API - default values' }
DrsStyleSheet >> defaultColor [

	^ Color black
]

{ #category : #'API - default values' }
DrsStyleSheet >> defaultFontName [

	^ 'Source Sans Pro'
]

{ #category : #'API - default values' }
DrsStyleSheet >> defaultFontSize [ 

	^ 10
]

{ #category : #'API - default values' }
DrsStyleSheet >> defaultMaxLabelWidth [

	^ 300
]

{ #category : #accessing }
DrsStyleSheet >> ensureAllClassesDefinitions [

	allClassesDefinitions ifNotNil: [ ^ allClassesDefinitions ].
	
	allClassesDefinitions := OrderedCollection new.
	
	children do: [ :aChild |
		aChild isStyleRule ifTrue: [ 
			aChild selector privSelectors do: [ :aSelector |
				allClassesDefinitions add: aChild ] ] ].
		
 ^ allClassesDefinitions 		
]

{ #category : #accessing }
DrsStyleSheet >> ensureStyleClasses [

	"cache styles for faster access"

	styleClasses ifNotNil: [ ^ styleClasses ].

	styleClasses := Dictionary new.

	children do: [ :aChild | 
		aChild isStyleRule ifTrue: [ 
			aChild selector privSelectors do: [ :aSelector | 
				aSelector isString
					ifTrue: [ 
						(styleClasses at: aSelector ifAbsentPut: [ SmallDictionary new ])
							at: #( default )
							put: aChild ]
					ifFalse: [ 
						| aClassName variantNames variantNamesKey |
						aClassName := aChild selector privSelectors first selectors
							              first value.
						variantNames := aChild selector privSelectors allButFirst 
							                collect: [ :each | each element ].
						variantNamesKey := (variantNames includes: #default)
							                   ifTrue: [ variantNames ]
							                   ifFalse: [ 
							                   variantNames copyWithFirst: #default ].
						(styleClasses
							 at: aClassName
							 ifAbsentPut: [ SmallDictionary new ])
							at: variantNamesKey
							put: aChild ] ] ] ].

	^ styleClasses
]

{ #category : #initialization }
DrsStyleSheet >> initialize [ 

	super initialize.
	
	stylesCache := Dictionary new.
	typeVariantsClasses := Dictionary new.
]

{ #category : #private }
DrsStyleSheet >> keyForCasses: styleClassNames variants: variantsCollection [ 

	^  (styleClassNames, variantsCollection) joinUsing: ' '.
]

{ #category : #initialization }
DrsStyleSheet >> postLoad [ 

	self ensureAllClassesDefinitions.
	self ensureStyleClasses.
	
	self collectTypeVariantsClasses.	
	self prefillStylesCache
]

{ #category : #private }
DrsStyleSheet >> prefillStylesCache [

	styleClasses keysAndValuesDo: [ :className :variantsDict | 
		variantsDict keysDo: [ :variantNames | 
			(self variantsCombinationsFrom: variantNames) do: [ 
				:variantCombination | 
				self
					privStylesFrom: { className }
					variants: variantCombination
					key:
					(self keyForCasses: { className } variants: variantCombination) ] ] ].
]

{ #category : #private }
DrsStyleSheet >> privNonCachedStylesFrom: styleClassNames variants: variantsCollection [

	| outputStyles variantCombinations |

	variantCombinations := self variantsCombinationsWithDefaultFrom:
		                       variantsCollection.

	outputStyles := DrsStyleProperties new.
	outputStyles styleClasses: styleClassNames.

	styleClassNames do: [ :styleClassName | 
		variantCombinations do: [ :variantsCombination | 
			| cssStyleRule |
			cssStyleRule := self
				                classNamed: styleClassName
				                variants: variantsCombination
				                ifPresent: [ :s | s ].
			cssStyleRule ifNotNil: [ outputStyles overwriteStyleRule: cssStyleRule ] ] ].

	^ outputStyles
]

{ #category : #private }
DrsStyleSheet >> privStylesFrom: styleClassNames variants: variantsCollection key: aKey [

	| outputStyles |
	stylesCache
		at: aKey
		ifPresent: [ :cached | ^ cached ].

	outputStyles := self
		                privNonCachedStylesFrom: styleClassNames
		                variants: variantsCollection.

	stylesCache at: aKey put: outputStyles.

	^ outputStyles
]

{ #category : #accessing }
DrsStyleSheet >> stylesFrom: styleClassNames key: aKey [

	^ self
		  privStylesFrom: styleClassNames
		  variants: #(default)
		  key: aKey
]

{ #category : #accessing }
DrsStyleSheet >> stylesFrom: styleClassNames variants: variantsCollection [

	| aKey | 
	
	aKey := self keyForCasses: styleClassNames variants: variantsCollection.

	^ self
		  privStylesFrom: styleClassNames
		  variants: variantsCollection
		  key: aKey
]

{ #category : #accessing }
DrsStyleSheet >> stylesFrom: styleClassNames variants: styleVariants key: aKey [

	^ self
		  privStylesFrom: styleClassNames
		  variants: styleVariants
		  key: aKey
]

{ #category : #accessing }
DrsStyleSheet >> stylesFromConfigurations: styleConfigurations variants: variantsCollection [

	| styleClassNames aKey | 
	
	styleConfigurations ifEmpty: [ ^ DrsStyleProperties new ].
	
	styleClassNames := (styleConfigurations first: 1) flatCollect: [ :each | 
		                   each styleClasses ].
	styleClassNames := styleClassNames collect: [ :each | 
		                   each withoutPrefix: '.' ].
	aKey := self keyForCasses: styleClassNames variants: variantsCollection.

	^ self
		  privStylesFrom: styleClassNames
		  variants: variantsCollection
		  key: aKey
]

{ #category : #accessing }
DrsStyleSheet >> typeVariantsClasses [

	^ typeVariantsClasses
]

{ #category : #accessing }
DrsStyleSheet >> typeVariantsStylesForClassName: tvClassName [

	^ typeVariantsClasses at: tvClassName ifAbsent: [ 
		typeVariantsClasses at: (tvClassName withoutPrefix: '.') ifAbsent: [  ]
	 ]

]

{ #category : #private }
DrsStyleSheet >> variantsCombinationsFrom: variantsCollection [

	| allVariants |
	allVariants := OrderedCollection new.

	1 to: variantsCollection size do: [ :index | 
	allVariants add: (variantsCollection first: index) ].

	^ allVariants asArray
]

{ #category : #private }
DrsStyleSheet >> variantsCombinationsWithDefaultFrom: variantsCollection [

	^ self variantsCombinationsFrom:
		  ((variantsCollection includes: #default)
			   ifTrue: [ variantsCollection ]
			   ifFalse: [ variantsCollection copyWithFirst: #default ])
]
