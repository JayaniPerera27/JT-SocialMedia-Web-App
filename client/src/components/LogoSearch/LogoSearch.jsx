// import React from "react";
// import Logo from "../../img/logo.png";
// import './LogoSearch.css'
// import { UilSearch } from '@iconscout/react-unicons'
// const LogoSearch = () => {
//   return (
//     <div className="LogoSearch">
//       <img src={Logo} alt="" />
//       <div className="Search">
//           <input type="text" placeholder="#Explore"/>
//           <div className="s-icon">
//                 <UilSearch/>
//           </div>
//       </div>
//     </div>
//   );
// };

// export default LogoSearch;

// import React, { useState } from "react";
// import Logo from "../../img/logo.png";
// import "./LogoSearch.css";
// import { UilSearch } from "@iconscout/react-unicons";

// const LogoSearch = ({ onSearch }) => {
//   const [searchText, setSearchText] = useState("");

//   //  Handle Input Change
//   const handleInputChange = (e) => {
//     setSearchText(e.target.value);
//   };

//   //  Handle Search Action
//   const handleSearch = () => {
//     if (onSearch) {
//       onSearch(searchText); // Call the search function passed from parent
//     }
//   };

//   //  Allow Searching by Pressing "Enter"
//   const handleKeyPress = (e) => {
//     if (e.key === "Enter") {
//       handleSearch();
//     }
//   };

//   return (
//     <div className="LogoSearch">
//       <img src={Logo} alt="Logo" />
//       <div className="Search">
//         <input
//           type="text"
//           placeholder="Search..."
//           value={searchText}
//           onChange={handleInputChange}
//           onKeyPress={handleKeyPress} // Press Enter to search
//         />
//         <div className="s-icon" onClick={handleSearch}>
//           <UilSearch />
//         </div>
//       </div>
//     </div>
//   );
// };

// export default LogoSearch;

import React, { useState } from "react";
import Logo from "../../img/logo.png";
import "./LogoSearch.css";
import { UilSearch } from "@iconscout/react-unicons";

const LogoSearch = ({ onSearch }) => {
  const [searchText, setSearchText] = useState("");

  // ✅ Handle Input Change
  const handleInputChange = (e) => {
    setSearchText(e.target.value);
  };

  // ✅ Handle Search Action
  const handleSearch = () => {
    if (onSearch) {
      onSearch(searchText.trim()); // Pass search value to parent component
    }
  };

  // ✅ Allow Searching by Pressing "Enter"
  const handleKeyPress = (e) => {
    if (e.key === "Enter") {
      handleSearch();
    }
  };

  return (
    <div className="LogoSearch">
      <img src={Logo} alt="Logo" />
      <div className="Search">
        <input
          type="text"
          placeholder="Search..."
          value={searchText}
          onChange={handleInputChange}
          onKeyPress={handleKeyPress} // Press Enter to search
        />
        <div className="s-icon" onClick={handleSearch}> {/* ✅ Clickable Icon */}
          <UilSearch />
        </div>
      </div>
    </div>
  );
};

export default LogoSearch;


