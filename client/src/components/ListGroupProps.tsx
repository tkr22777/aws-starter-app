import { MouseEvent, useState } from "react";

interface Props {
  items: string[];
  heading?: string; // ? means heading is optional
  onSelectItem: (item: string) => void;
}

function ListGroupProps({items, heading = "default", onSelectItem}: Props) {

  const [selectedIndex, setSelectedIndex] = useState(-1)

  const getMessage = () => {
    return items.length === 0 ? <p>No iteams found</p> : null;
  };

  const handleClick = (event: MouseEvent) => {
    //console.log("Clicked: " + item + " Index:" + index);
    console.log(event);
  }

  return (
    // empty <> to add fragment
    <>
      <h1>{heading}</h1>
      {getMessage()}
      {items.length === 0 && <p>No iteams found</p>}
      <ul className="list-group">
        {items.map((item, index) => (
          <li
            className= {
                selectedIndex === index 
                ? "list-group-item active"
                : "list-group-item"
            }
            key={item}
            onClick= { (event) => {
                setSelectedIndex(index);
                onSelectItem(item);
            }}
          >
            {item}
          </li>
        ))}
      </ul>
    </>
  );
}

export default ListGroupProps;
