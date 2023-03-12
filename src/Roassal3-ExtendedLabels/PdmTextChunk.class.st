"
A piece of text with assigned style classes. The style are valid for all the chunk content.

lookUp key is precomputed value for easier look-up of precomputed style combinations in the stylesheet
"
Class {
	#name : #PdmTextChunk,
	#superclass : #Object,
	#instVars : [
		'styleClassNames',
		'lookUpKey',
		'styleVariants'
	],
	#category : #'Roassal3-ExtendedLabels-Text'
}

{ #category : #'instance creation' }
PdmTextChunk class >> with: anObject style: styleClassName [ 

	^ self new initializeWith: anObject styles: { styleClassName }.
]

{ #category : #'instance creation' }
PdmTextChunk class >> with: anObject styles: styleClassNames [

	^ self new initializeWith: anObject styles: styleClassNames.
]

{ #category : #'instance creation' }
PdmTextChunk class >> with: anObject styles: styleClassNames variants: styleVariants [

	^ self new initializeWith: anObject styles: styleClassNames variants: styleVariants
]

{ #category : #accessing }
PdmTextChunk >> asLabelChunk [ 

	self subclassResponsibility 
]

{ #category : #initialization }
PdmTextChunk >> initializeWith: anObject styles: aCollectionOfNames [

	"by default, anObject is ignormed"

	styleClassNames := aCollectionOfNames asArray.
	lookUpKey := styleClassNames joinUsing: ' '	.

]

{ #category : #initialization }
PdmTextChunk >> initializeWith: anObject styles: aCollectionOfNames  variants: variants [

	"by default, anObject is ignormed"

	styleClassNames := aCollectionOfNames asArray.
	styleVariants := variants.
	lookUpKey := (styleClassNames, styleVariants) joinUsing: ' '.

]

{ #category : #'API - lookUp' }
PdmTextChunk >> lookUpKey [ 

	^ lookUpKey
]

{ #category : #accessing }
PdmTextChunk >> styleClassNames [

	^ styleClassNames
]

{ #category : #accessing }
PdmTextChunk >> styleVariants [

	^ styleVariants
]

{ #category : #accessing }
PdmTextChunk >> styleVariants: anObject [

	styleVariants := anObject
]
