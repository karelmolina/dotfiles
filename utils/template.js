const generateSnippetMark = (i) => {
  return '<`' + i + ':description`>'
}

const formatParam = (param, i) => {
  if (param.alias) {
    if (param.name) {
      return `${param.name} {${param.alias}} - ` + generateSnippetMark(i++)
    }
    return param.alias
  }

  if (param.name) {
    return `${param.name} {${param.type}} - ` + generateSnippetMark(i++)
  }
  return `{${param.type}}`
}

const generateClassDoc = (doc) => {
  const d =
    doc.heritageClauses.length === 0
      ? `
/**
 * ` + '<`0:name`>' + `
 */`
      : `
/**
 * ` + '<`0:name`>' + `
 *
 * @${doc.heritageClauses.map((h) => `${h.type} ${h.value}`).join('\n * @')}
 */`

  return d.trim()
}

module.exports = {
  generateClassDoc,
  generateInterfaceDoc: generateClassDoc,
  generatePropertyDoc: (doc) => {
    return `
/**
 * @type {${doc.returnType}}
 */`.trimLeft()
  },
  generateFunctionDoc: (doc) => {
    const start =
      doc.params.length === 0
        ? `
/**
 * ` + `${doc.name}`
        : `
/**
 * ` + `${doc.name}` + `
 *
 * @${doc.params.map(formatParam).join('\n * @')}`

    const delimiter =
      doc.params.length === 0 && doc.returnType !== ''
        ? `
 *`
        : ``

    const end = doc.returnType
      ? `
 * @returns {${doc.returnType}} ` + '<`0:return value`>' + `
 */`
      : `
 */`
    return `${start.trimLeft()}${delimiter}${end.trimRight()}`
  },
}
