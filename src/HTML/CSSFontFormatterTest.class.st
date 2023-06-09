Class {
	#name : #CSSFontFormatterTest,
	#superclass : #TestCase,
	#instVars : [
		'fontFormatter'
	],
	#category : #'HTML-CSS-Tests'
}

{ #category : #accessing }
CSSFontFormatterTest >> fontFormatter [

	^ fontFormatter
]

{ #category : #accessing }
CSSFontFormatterTest >> fontFormatter: anObject [

	fontFormatter := anObject
]

{ #category : #running }
CSSFontFormatterTest >> setUp [
	self timeLimit: 60 seconds.
	self fontFormatter: CSSFontFormatter new
]

{ #category : #testing }
CSSFontFormatterTest >> test01FontItalicBoldShouldBeParsedCorrectly [
	| prop result |
	result := Dictionary new.
	prop := CSSProperty new
				propertyName: 'font';
				propertyString: 'italic bold medium Verdana';
				yourself.
	self fontFormatter parseTextAttributesFrom: prop into: result.
	self assert: true equals: (result at: #italic).
	self assert: true equals: (result at: #bold)
]

{ #category : #testing }
CSSFontFormatterTest >> test02FontStyleItalicShouldBeParsedCorrectly [
	| prop result |
	result := Dictionary new.
	prop := CSSProperty new
				propertyName: 'font-style';
				propertyString: 'italic';
				yourself.
	self fontFormatter parseTextAttributesFrom: prop into: result.
	self assert: (result at: #italic) equals: true
]

{ #category : #testing }
CSSFontFormatterTest >> test03FontWeightBoldShouldBeParsedCorrectly [
	| prop result |
	result := Dictionary new.
	prop := CSSProperty new
				propertyName: 'font-weight';
				propertyString: 'bold';
				yourself.
	self fontFormatter parseTextAttributesFrom: prop into: result.
	self assert: (result at: #bold) equals: true.
]

{ #category : #testing }
CSSFontFormatterTest >> test04ComplexFontValueShouldBeParsedCorrectly [
	| prop result |
	result := Dictionary new.
	prop := CSSProperty new
				propertyName: 'font';
				propertyString: 'bold xx-large/180% Verdana';
				yourself.
	self fontFormatter parseTextAttributesFrom: prop into: result.
	self assert: false equals: (result at: #italic).
	self assert: true equals: (result at: #bold).
	self assert: 3 * CSSFontFormatter defaultSize equals: (result at: #fontSize).
	self assert: (TextStyle default) equals: (result at: #fontFamily).
]

{ #category : #testing }
CSSFontFormatterTest >> test05FontFamilyShouldBeParsedCorrectly [
	| prop result |
	result := Dictionary new.
	prop := CSSProperty new
				propertyName: 'font-family';
				propertyString: 'non-existent, serif, sans-serif';
				yourself.
	self fontFormatter parseTextAttributesFrom: prop into: result.
	self assert: (TextStyle default) equals: (result at: #fontFamily).

]

{ #category : #testing }
CSSFontFormatterTest >> test06FontSizeShouldBeParsedCorrectly [
	| prop result |
	result := Dictionary new.
	prop := CSSProperty new
				propertyName: 'font-size';
				propertyString: '12pt';
				yourself.
	self fontFormatter parseTextAttributesFrom: prop into: result.
	self assert: 12 / 72 * TextStyle pixelsPerInch equals: (result at: #fontSize).
]
