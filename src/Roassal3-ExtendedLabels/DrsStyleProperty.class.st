Class {
	#name : #DrsStyleProperty,
	#superclass : #Association,
	#classVars : [
		'Styles'
	],
	#category : #'Roassal3-ExtendedLabels-Styles'
}

{ #category : #initialization }
DrsStyleProperty class >> initialize [

	<script>

	self initializeStyles
]

{ #category : #initialization }
DrsStyleProperty class >> initializeLabelStyles [

	<script>

	Styles := Dictionary new.
	
	Styles at: #textColor put: (self key: #textColor value: Color black).
]

{ #category : #initialization }
DrsStyleProperty class >> initializeStyles [

	<script>

	self initializeLabelStyles.
]

{ #category : #initialization }
DrsStyleProperty class >> onJson: aJsonObj [ 

	| className aClass | 
	
	className := aJsonObj at: #className ifAbsent: [ self pdmError: #PdmInvalidJsonObject].
	aClass := self class environment at: className asSymbol ifAbsent: [ self pdmError: #PdmInvalidJsonObject ].

	^ aClass new initOnJson: aJsonObj 
]

{ #category : #'as yet unclassified' }
DrsStyleProperty class >> styleAt: aKey [

	^ Styles at: aKey
]

{ #category : #'as yet unclassified' }
DrsStyleProperty class >> textColor [

	^ Styles at: #textColor
]

{ #category : #accessing }
DrsStyleProperty >> defaultValue [

	^ value
]

{ #category : #accessing }
DrsStyleProperty >> initOnJson: aJsonObj [

	| className aClass |

	key := (aJsonObj at: #key ifAbsent: [ self pdmError: #PdmInvalidJsonObject ]). 
	value := (aJsonObj at: #value ifAbsent: [ self pdmError: #PdmInvalidJsonObject ]).
	
	value isJsonObject ifFalse: [^ self ].
	
	className := aJsonObj at: #className ifAbsent: [ self pdmError: #PdmInvalidJsonObject ].
	aClass := self class environment at: className asSymbol ifAbsent: [ self pdmError: #PdmInvalidJsonObject ].
	value := aClass onJson: value.
	
]

{ #category : #accessing }
DrsStyleProperty >> keysAndValuesForJson [

	| assocs | 
	
	assocs := { 
		#className -> self className.
		#key -> self key.
		#value -> self value.
		
	}.
	
	^ assocs 
]

{ #category : #accessing }
DrsStyleProperty >> value: aValue [

	self pdmDeveloperHalt: 'Should not be called as class has been removed'.
	"^ DrsStyleValue key: self key value: aValue"
]
