"
A dictionary of DrsStyleProperties, representing a specific subset of style rules

styleClasses - stores class names used for creation of the style properties
"
Class {
	#name : #DrsStyleProperties,
	#superclass : #Object,
	#instVars : [
		'styleClasses',
		'properties',
		'boxProperties'
	],
	#category : #'Roassal3-ExtendedLabels-Styles'
}

{ #category : #accessing }
DrsStyleProperties class >> merge: drsStyles [
 
	| styles | 
	styles := self new.
	drsStyles do: [ :each | styles merge: each ].
	^ styles 
]

{ #category : #accessing }
DrsStyleProperties class >> onJson: aJsonObj [ 

	| className aClass | 
	
	className := aJsonObj at: #className ifAbsent: [ self pdmError: #PdmInvalidJsonObject].
	aClass := self class environment at: className asSymbol ifAbsent: [ self pdmError: #PdmInvalidJsonObject ].

	^ aClass new initOnJson: aJsonObj 
]

{ #category : #accessing }
DrsStyleProperties class >> with: styles [ 

	^ self new addStyles: styles; yourself
	
]

{ #category : #API }
DrsStyleProperties >> addProperty: aStyle [

	properties at: aStyle key put: aStyle
]

{ #category : #API }
DrsStyleProperties >> addStyleRule: cssStyleRule [ 

	^ cssStyleRule properties do: [ :each | self addProperty: each asDrsStyleProperty ]
]

{ #category : #API }
DrsStyleProperties >> addStyles: stylesCollection [

	stylesCollection do: [ :each | 
		self addProperty: each ]
]

{ #category : #accessing }
DrsStyleProperties >> boxProperties [ 

	^ boxProperties ifNil: [ 
		| defaultPadding | 
		
		boxProperties := DrsLabelBoxProperties new.
		defaultPadding := 0.

		(self get: 'padding' defaultValue: nil) ifNotNil: [ :val |
			defaultPadding := val.
		].

		boxProperties cornerRadius: (self get: 'cornerRadius' defaultValue: 0).
		boxProperties paddingLeft: (self get: 'padding-left' defaultValue: defaultPadding).
		boxProperties paddingRight: (self get: 'padding-right' defaultValue: defaultPadding).
		boxProperties paddingTop: (self get: 'padding-top' defaultValue: defaultPadding).
		boxProperties paddingBottom: (self get: 'padding-bottom' defaultValue: defaultPadding).
		boxProperties color: (self get: 'fillColor' defaultValue: Color white).
		boxProperties borderColor: (self get: 'borderColor' defaultValue: Color gray).
		boxProperties borderWidth: (self get: 'borderWidth' defaultValue: 0).
		boxProperties hoverFillColor: (self get: 'mouseOverFillColor' defaultValue: nil).
		boxProperties hoverBorderColor: (self get: 'mouseOverBorderColor' defaultValue: nil).
		boxProperties iconOffset: (self get: 'iconOffset' defaultValue: 0).
		boxProperties.
	]
]

{ #category : #API }
DrsStyleProperties >> findBestMatchForLocalized: propertyBaseName isoLanguage: isoId [
	"If nothing exists for the given isoId, we take the first entry - unless there is an entry without suffix."
	
	| availableProps suffix bestMatchName regularNameMatch |
	availableProps := self propertiesNamed: propertyBaseName includeLocalized: true.
	availableProps size = 1 
		ifTrue: [ ^ availableProps first ].
		suffix := '-' , isoId , '-'.
	bestMatchName := propertyBaseName, suffix.
	regularNameMatch := nil.
	
	availableProps do: [ :ls |
		ls name = bestMatchName 
			ifTrue: [ ^ ls ].
		ls name = propertyBaseName 
			ifTrue: [ regularNameMatch := ls ].
	].
	^ regularNameMatch
		ifNotNil: [ regularNameMatch ]
		ifNil: [ availableProps first ].
]

{ #category : #API }
DrsStyleProperties >> get: propertyName [

	^ (properties at: propertyName key ifAbsent: [ 
		| styleRecord |
		styleRecord := DrsStyleProperty styleAt: propertyName.
		styleRecord defaultValue]) value.
]

{ #category : #API }
DrsStyleProperties >> get: propertyName defaultValue: defaultValue [

	^ (properties at: propertyName ifAbsent: [defaultValue ]) value.
	
]

{ #category : #accessing }
DrsStyleProperties >> hasPropertyNamed: aSymbol [

	^ properties includesKey: aSymbol
]

{ #category : #accessing }
DrsStyleProperties >> initialize [ 

	super initialize.
	properties := Dictionary new.
	styleClasses := OrderedCollection new.

]

{ #category : #accessing }
DrsStyleProperties >> keysAndValuesForJson [

	| assocs | 
	
	assocs := { 
		#className -> self className.
		#properties -> self properties.
	}.
	
	^ assocs 
]

{ #category : #accessing }
DrsStyleProperties >> merge: otherStyles [ 

	otherStyles do: [ :stls |
		stls properties do: [ :otherStyle |
			(self hasPropertyNamed: otherStyle key) 
				ifFalse: [ self addProperty: otherStyle ] ] ]
]

{ #category : #API }
DrsStyleProperties >> overwriteStyle: aStyle [

	properties at: aStyle key put: aStyle
]

{ #category : #API }
DrsStyleProperties >> overwriteStyleRule: cssStyleRule [

	^ cssStyleRule properties do: [ :each | 
		  self overwriteStyle: each asDrsStyleProperty ]
]

{ #category : #accessing }
DrsStyleProperties >> properties [
	
	^ properties
]

{ #category : #API }
DrsStyleProperties >> propertiesNamed: aSymbol includeLocalized: shallIncludeLocalized [

	| matchPattern |
	shallIncludeLocalized
		ifFalse: [ ^ OrderedCollection with: (self stylePropertyNamed: aSymbol) ].
	matchPattern := aSymbol, '-##-'.
	^ properties values select: [ :e | e key = aSymbol or: [ matchPattern match: e key ] ]
]

{ #category : #API }
DrsStyleProperties >> propertiesWithBaseName: aSymbol includeVariants: shallIncludeVariants [

	| matchPattern |
	shallIncludeVariants ifFalse: [ 
		^ OrderedCollection with: (self stylePropertyNamed: aSymbol)
	].
	matchPattern := aSymbol, '-*'.
	^ properties values select: [ :e | e key = aSymbol or: [ matchPattern match: e key ] ]
]

{ #category : #accessing }
DrsStyleProperties >> styleClasses [

	^ styleClasses
]

{ #category : #accessing }
DrsStyleProperties >> styleClasses: anObject [

	styleClasses := anObject
]

{ #category : #API }
DrsStyleProperties >> stylePropertyNamed: aSymbol [

	^ self get: aSymbol defaultValue: nil
]
