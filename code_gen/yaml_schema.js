import joi from 'joi'

const dataTypes = ['string', 'int16', 'int32', 'int64', 'bool', 'json', 'binary', 'date', 'time', 'enum']

export const Postgres = 1
export const MySQL = 2
export const SQLite = 3

export const notNull = 'not_null'
export const id = 'id'
export const randomId = 'random_id'
export const unique = 'unique'

export const schema = joi.object({
  name: joi.string().required(),
  properties: joi.array().items(
    joi.object({
      _name: joi.string().required(),
      tags: joi.array().items(joi.string().valid(id, randomId, notNull, unique)),
      type: joi
        .string()
        .valid(...dataTypes)
        .required(),
      refrences: joi.string().pattern(/^\w+\.\w+$/),
      max_length: joi.number().integer(),
      info: joi.string(),
      values: joi.array().items(joi.string()),
    })
  ),
  type: joi.string().equal('object').required(),
  info: joi.string(),
})
