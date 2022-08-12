export const getArrObjectsProperties = function (objectName) {
  const arr = [];
  Object.keys(objectName).forEach((prop) => {
    if (Object.prototype.hasOwnProperty.call(objectName, prop)) {
      arr.push(prop);
    }
  });
  return arr;
};
export const propertiesToArray = function (arrObjects, labelfieldName, filterLabel) {
  const method = "propertiesToArray";
  console.log(`##-->${method} label:${labelfieldName}, filter:${filterLabel} `);
  if ((arrObjects === undefined) || (arrObjects == null)) {
    return null;
  }
  if (arrObjects.length > 0) {
    let objResults = {};
    const arrProps = getArrObjectsProperties(arrObjects.pop());
    // console.log(`##-->${method} arrProps`, arrProps);
    arrProps.forEach((field) => {
      objResults[field] = [];
    });
    // console.log(`##-->${method} objResults`, objResults);
    if (filterLabel !== undefined && filterLabel !== null) {
      const arrFiltered = arrObjects.filter( v => v[labelfieldName].search(filterLabel) > -1 );
      // console.log(`##-->${method} arrFiltered`, arrFiltered);
      arrFiltered.forEach((item) => {
        arrProps.forEach((field) => {
          objResults[field].push(item[field]);
        });
      });
    } else {
      arrObjects.forEach((item) => {
        arrProps.forEach((field) => {
          objResults[field].push(item[field]);
        });
      });
    }
    return objResults;
  }
  return null;
};
