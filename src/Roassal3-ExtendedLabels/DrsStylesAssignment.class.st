Class {
	#name : #DrsStylesAssignment,
	#superclass : #Object,
	#instVars : [
		'styleClasses'
	],
	#category : #'Roassal3-ExtendedLabels-Styles'
}

{ #category : #accessing }
DrsStylesAssignment class >> merge: drsStyles [
 
	| styles | 
	styles := self new.
	drsStyles do: [ :each | styles merge: each ].
	^ styles 
]

{ #category : #accessing }
DrsStylesAssignment class >> onJson: aJsonObj [ 

	| className aClass | 
	
	className := aJsonObj at: #className ifAbsent: [ self pdmError: #PdmInvalidJsonObject].
	aClass := self class environment at: className asSymbol ifAbsent: [ self pdmError: #PdmInvalidJsonObject ].

	^ aClass new initOnJson: aJsonObj 
]

{ #category : #accessing }
DrsStylesAssignment class >> styleClasses: aCollection [ 

	^ self new styleClasses: aCollection
]

{ #category : #accessing }
DrsStylesAssignment class >> with: styles [ 

	^ self new addStyles: styles; yourself
	
]

{ #category : #accessing }
DrsStylesAssignment >> initOnJson: aJsonObj [

	| jsonStyles |
	
	jsonStyles := (aJsonObj at: #styles ifAbsent: [ Array new ]). 
	styleClasses := aJsonObj at: #styleClasses ifAbsent: [Array new].
]

{ #category : #accessing }
DrsStylesAssignment >> initialize [ 

	super initialize.
	styleClasses := OrderedCollection new. 
]

{ #category : #accessing }
DrsStylesAssignment >> keysAndValuesForJson [

	| assocs | 
	
	assocs := { 
		#className -> self className.
		#styleClasses -> self styleClasses.
	}.
	
	^ assocs 
]

{ #category : #accessing }
DrsStylesAssignment >> styleClasses [

	^ styleClasses
]

{ #category : #accessing }
DrsStylesAssignment >> styleClasses: aCollection [

	styleClasses := aCollection
]
